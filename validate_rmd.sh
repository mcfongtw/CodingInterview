#!/bin/sh
#
# R Markdown Source Validation Script
# Validates .Rmd files for common syntax issues before building
#

set -e

VERBOSE=${1:-false}

if [ "$VERBOSE" = "--verbose" ] || [ "$VERBOSE" = "-v" ]; then
    VERBOSE=true
    echo "========================================="
    echo "R Markdown Source Validation"
    echo "========================================="
    echo ""
else
    VERBOSE=false
fi

# Count .Rmd files
RMD_COUNT=$(ls *.Rmd 2>/dev/null | wc -l | tr -d ' ')
if [ "$RMD_COUNT" -eq 0 ]; then
    echo "❌ No .Rmd files found"
    exit 1
fi

if [ "$VERBOSE" = "true" ]; then
    echo "Validating $RMD_COUNT .Rmd files..."
    echo ""
fi

# Run Python validation script
python3 - "$VERBOSE" << 'PYEOF'
import sys
import glob
import re

verbose = sys.argv[1] == 'true'

class RmdValidator:
    def __init__(self):
        self.errors = []
        self.warnings = []
        self.files_checked = 0

    def validate_all(self):
        """Validate all .Rmd files"""
        rmd_files = sorted(glob.glob('*.Rmd'))

        for filepath in rmd_files:
            self.files_checked += 1
            self.validate_file(filepath)

        return len(self.errors) == 0

    def validate_file(self, filepath):
        """Validate a single .Rmd file"""
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        self._check_code_fences(filepath, lines)
        self._check_duplicate_anchors(filepath, lines)
        self._check_problematic_patterns(filepath, lines)

    def _check_code_fences(self, filepath, lines):
        """Check code fence syntax (```, not ``)"""
        in_block = False
        block_start = 0
        block_type = ""

        for i, line in enumerate(lines, 1):
            stripped = line.strip()

            # Check for `` pattern (should be ```)
            if stripped == '``':
                self.errors.append(
                    f"{filepath}:{i}: Found '``' (two backticks) - should be '```' (three backticks)"
                )

            # Check for ```## pattern (fence and header on same line)
            if '```##' in line:
                self.errors.append(
                    f"{filepath}:{i}: Code fence and section header on same line: ```##"
                )

            # Track code block state
            if re.match(r'^```\w+', stripped):  # Opening fence with language
                if in_block:
                    self.errors.append(
                        f"{filepath}:{i}: Nested code block (previous block at line {block_start})"
                    )
                in_block = True
                block_start = i
                block_type = stripped[3:]
            elif stripped == '```':  # Closing fence
                if not in_block:
                    self.warnings.append(
                        f"{filepath}:{i}: Closing '```' without opening"
                    )
                else:
                    in_block = False
            elif in_block and line.startswith('##'):  # Section header inside block
                self.errors.append(
                    f"{filepath}:{i}: Section header '##' inside code block (block started at line {block_start})"
                )
                in_block = False

        # Check if block was never closed
        if in_block:
            self.errors.append(
                f"{filepath}:{block_start}: Code block '{block_type}' never closed (reached EOF)"
            )

    def _check_duplicate_anchors(self, filepath, lines):
        """Check for duplicate anchor IDs within a file"""
        anchors = {}
        for i, line in enumerate(lines, 1):
            # Find all {#anchor-id} patterns
            matches = re.findall(r'\{#([^}]+)\}', line)
            for anchor in matches:
                if anchor in anchors:
                    self.errors.append(
                        f"{filepath}:{i}: Duplicate anchor '#{anchor}' (first seen at line {anchors[anchor]})"
                    )
                else:
                    anchors[anchor] = i

    def _check_problematic_patterns(self, filepath, lines):
        """Check for other problematic patterns"""
        for i, line in enumerate(lines, 1):
            # Check for @ref with spaces
            refs = re.findall(r'\\@ref\(([^)]+)\)', line)
            for ref in refs:
                if ' ' in ref:
                    self.warnings.append(
                        f"{filepath}:{i}: Reference '@ref({ref})' contains spaces"
                    )

            # Check for section headers without proper spacing
            if line.startswith('##') and not line.startswith('## ') and len(line.strip()) > 2:
                self.warnings.append(
                    f"{filepath}:{i}: Section header missing space after '##'"
                )

    def print_results(self):
        """Print validation results"""
        if verbose:
            print("=" * 60)
            print("VALIDATION RESULTS")
            print("=" * 60)
            print(f"Files checked: {self.files_checked}")
            print()

        if self.errors:
            if not verbose:
                print()
            print(f"❌ ERRORS ({len(self.errors)}):")
            for error in self.errors:
                print(f"   {error}")
            print()

        if self.warnings and verbose:
            print(f"⚠️  WARNINGS ({len(self.warnings)}):")
            for warning in self.warnings:
                print(f"   {warning}")
            print()

        if not self.errors and not self.warnings:
            if verbose:
                print("✅ All validations passed!")
                print()
            else:
                print("✅ Validation passed")
            return True
        elif not self.errors:
            if verbose:
                print(f"✅ No errors found ({len(self.warnings)} warnings)")
                print()
            else:
                print(f"✅ Validation passed ({len(self.warnings)} warnings)")
            return True
        else:
            print(f"❌ Validation failed: {len(self.errors)} errors, {len(self.warnings)} warnings")
            print()
            return False

# Run validation
validator = RmdValidator()
success = validator.validate_all()
validator.print_results()

sys.exit(0 if success else 1)
PYEOF

VALIDATION_EXIT=$?

if [ $VALIDATION_EXIT -eq 0 ]; then
    if [ "$VERBOSE" = "true" ]; then
        echo "Safe to build!"
    fi
    exit 0
else
    echo "❌ Please fix the errors above before building"
    echo "   Run with --verbose flag for more details: sh validate_rmd.sh --verbose"
    exit 1
fi
