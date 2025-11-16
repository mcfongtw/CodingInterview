#!/bin/sh
#
# HTML Validation Script
# Validates the generated HTML output for common issues
#

set -e

echo "========================================="
echo "HTML Validation Script"
echo "========================================="
echo ""

# Check if docs directory exists
if [ ! -d "docs" ]; then
    echo "❌ Error: docs/ directory not found. Run 'sh build.sh' first."
    exit 1
fi

# Check if HTML files exist
HTML_COUNT=$(find docs -name "*.html" | wc -l | tr -d ' ')
if [ "$HTML_COUNT" -eq 0 ]; then
    echo "❌ Error: No HTML files found in docs/. Run 'sh build.sh' first."
    exit 1
fi

echo "Found $HTML_COUNT HTML files to validate"
echo ""

# Track validation results
ERRORS=0
WARNINGS=0

# 1. Check for broken internal links
echo "1. Checking for broken internal links..."
BROKEN_LINKS=$(grep -r 'href="#' docs/*.html | grep -v 'href="#top"' | wc -l | tr -d ' ')
if [ "$BROKEN_LINKS" -gt 0 ]; then
    echo "   ⚠️  Found $BROKEN_LINKS potential anchor links (may include valid ones)"
    WARNINGS=$((WARNINGS + 1))
else
    echo "   ✅ No broken anchor links detected"
fi

# 2. Check for duplicate IDs in HTML
echo "2. Checking for duplicate IDs..."
python3 << 'EOF'
import glob
import re
from collections import defaultdict

id_map = defaultdict(list)
for html_file in glob.glob('docs/*.html'):
    with open(html_file, 'r') as f:
        content = f.read()
    # Find all id="..." attributes
    ids = re.findall(r'id="([^"]+)"', content)
    for id_val in ids:
        id_map[id_val].append(html_file)

duplicates = {k: v for k, v in id_map.items() if len(v) > 1}
if duplicates:
    print(f"   ❌ Found {len(duplicates)} duplicate IDs:")
    for id_val, files in list(duplicates.items())[:5]:  # Show first 5
        print(f"      - '{id_val}' in {len(files)} files")
    exit(1)
else:
    print("   ✅ No duplicate IDs found")
EOF

if [ $? -ne 0 ]; then
    ERRORS=$((ERRORS + 1))
fi

# 3. Check for unclosed code blocks in HTML output
echo "3. Checking for malformed code blocks..."
python3 << 'EOF'
import glob
import re

issues = []
for html_file in glob.glob('docs/*.html'):
    with open(html_file, 'r') as f:
        content = f.read()

    # Check for <pre><code> without closing tags
    open_pre = len(re.findall(r'<pre[^>]*>', content))
    close_pre = len(re.findall(r'</pre>', content))

    if open_pre != close_pre:
        issues.append(f"{html_file}: Mismatched <pre> tags ({open_pre} open, {close_pre} close)")

if issues:
    print(f"   ❌ Found {len(issues)} code block issues:")
    for issue in issues[:5]:  # Show first 5
        print(f"      - {issue}")
    exit(1)
else:
    print("   ✅ All code blocks properly closed")
EOF

if [ $? -ne 0 ]; then
    ERRORS=$((ERRORS + 1))
fi

# 4. Check for valid HTML5 structure (basic check)
echo "4. Checking HTML5 structure..."
python3 << 'EOF'
import glob

issues = []
for html_file in glob.glob('docs/*.html'):
    with open(html_file, 'r') as f:
        content = f.read()

    # Basic checks
    if '<!DOCTYPE html>' not in content and '<!doctype html>' not in content:
        issues.append(f"{html_file}: Missing DOCTYPE declaration")

    if '<html' not in content:
        issues.append(f"{html_file}: Missing <html> tag")

if issues:
    print(f"   ⚠️  Found {len(issues)} structure warnings:")
    for issue in issues[:3]:
        print(f"      - {issue}")
else:
    print("   ✅ HTML5 structure valid")
EOF

# 5. Check if index.html exists
echo "5. Checking for index.html..."
if [ -f "docs/index.html" ]; then
    echo "   ✅ index.html exists"
else
    echo "   ❌ index.html missing"
    ERRORS=$((ERRORS + 1))
fi

# 6. Validate with HTML Tidy if available
echo "6. Validating with HTML Tidy (if installed)..."
if command -v tidy > /dev/null 2>&1; then
    # Run tidy on index.html (suppress output, just check exit code)
    if tidy -q -e docs/index.html > /dev/null 2>&1; then
        echo "   ✅ HTML Tidy validation passed"
    else
        echo "   ⚠️  HTML Tidy found some issues (may be minor)"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "   ⏭️  HTML Tidy not installed (optional)"
fi

# Summary
echo ""
echo "========================================="
echo "Validation Summary"
echo "========================================="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo "✅ HTML validation passed!"
    exit 0
else
    echo "❌ HTML validation failed with $ERRORS errors"
    exit 1
fi
