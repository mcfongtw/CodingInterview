#!/bin/sh
#
# Build script for Technical Interview book
#
# Usage:
#   sh build.sh [format] [--skip-validation]
#   sh build.sh --preview
#
# Formats:
#   gitbook (default) - HTML for GitHub Pages
#   pdf               - PDF output
#   epub              - EPUB output
#   all               - Build all formats
#
# Options:
#   --skip-validation - Skip source validation (not recommended)
#   --preview         - Fast preview of git-changed .Rmd chapters only
#                       (cross-references to other chapters will not resolve)
#
# Note: Build time is displayed at the end of each build
#
# Examples:
#   sh build.sh                    # Full gitbook build with validation
#   sh build.sh pdf                # Build PDF with validation
#   sh build.sh all                # Build all formats
#   sh build.sh gitbook --skip-validation  # Build without validation
#   sh build.sh --preview          # Preview only changed chapters (fast)
#

set -e

# Start timer
START_TIME=$(date +%s)

# ── Preview mode: render only git-changed .Rmd files ──────────────────────────
if [ "$1" = "--preview" ]; then
    echo "========================================="
    echo "Preview mode: changed chapters only"
    echo "========================================="
    echo ""

    # Collect all changed files (staged + unstaged vs last commit)
    ALL_CHANGED=$(git diff HEAD --name-only 2>/dev/null || true)

    # If problems_data.csv changed, always include 14-problem-index.Rmd
    CSV_CHANGED=$(echo "$ALL_CHANGED" | grep '^problems_data\.csv$' || true)

    CHANGED=$(echo "$ALL_CHANGED" | grep '\.Rmd$' || true)

    if [ -n "$CSV_CHANGED" ]; then
        if ! echo "$CHANGED" | grep -q '^14-problem-index\.Rmd$'; then
            CHANGED=$(printf '%s\n%s' "$CHANGED" "14-problem-index.Rmd" | sed '/^$/d')
        fi
    fi

    if [ -z "$CHANGED" ]; then
        echo "No changed .Rmd files detected (git diff HEAD)."
        echo "Nothing to preview."
        echo ""
        echo "To build the full book: sh build.sh"
        exit 0
    fi

    echo "Changed files:"
    if [ -n "$CSV_CHANGED" ]; then
        echo "  problems_data.csv  (triggers 14-problem-index.Rmd)"
    fi
    for f in $CHANGED; do
        echo "  $f"
    done
    echo ""

    # Validate only the changed files
    echo "Validating changed files..."
    python3 - $CHANGED << 'PYEOF'
import sys, re

files = sys.argv[1:]
errors = []

for filepath in files:
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except FileNotFoundError:
        continue

    in_block = False
    block_start = 0
    block_type = ""
    anchors = {}

    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped == '``':
            errors.append(f"{filepath}:{i}: Found '``' - should be '```'")
        if '```##' in line:
            errors.append(f"{filepath}:{i}: Code fence and header on same line")
        if re.match(r'^```\w+', stripped):
            in_block = True; block_start = i; block_type = stripped[3:]
        elif stripped == '```':
            in_block = False
        elif in_block and line.startswith('##'):
            errors.append(f"{filepath}:{i}: Section header inside code block (started line {block_start})")
            in_block = False
        for anchor in re.findall(r'\{#([^}]+)\}', line):
            if anchor in anchors:
                errors.append(f"{filepath}:{i}: Duplicate anchor '#{anchor}'")
            else:
                anchors[anchor] = i

    if in_block:
        errors.append(f"{filepath}:{block_start}: Code block '{block_type}' never closed")

if errors:
    print(f"❌ ERRORS ({len(errors)}):")
    for e in errors: print(f"   {e}")
    sys.exit(1)
else:
    print("✅ Validation passed")
PYEOF

    echo ""

    # Preview each changed chapter
    for f in $CHANGED; do
        if [ -f "$f" ]; then
            echo "Previewing: $f"
            Rscript -e "suppressWarnings(bookdown::preview_chapter('$f'))"
            echo ""
        fi
    done

    echo "Preview complete. Output in _preview/"
    echo "Note: cross-references to other chapters will not resolve in preview mode."
    echo "Run 'sh build.sh' for a full build."
    echo ""

    # Calculate and display elapsed time
    END_TIME=$(date +%s)
    ELAPSED=$((END_TIME - START_TIME))
    MINUTES=$((ELAPSED / 60))
    SECONDS=$((ELAPSED % 60))
    echo "========================================="
    if [ $MINUTES -gt 0 ]; then
        echo "⏱  Build time: ${MINUTES}m ${SECONDS}s"
    else
        echo "⏱  Build time: ${SECONDS}s"
    fi
    echo "========================================="
    exit 0
fi

# ── Full build ─────────────────────────────────────────────────────────────────

# Default format is gitbook
FORMAT=${1:-gitbook}

echo "========================================="
echo "Building format: $FORMAT"
echo "========================================="
echo ""

# Run validation before building (unless --skip-validation flag is used)
if [ "$2" != "--skip-validation" ]; then
    if ! sh validate_rmd.sh; then
        echo "   To skip validation (not recommended): sh build.sh $FORMAT --skip-validation"
        exit 1
    fi
fi

echo "Note: Gitbook format may show a Pandoc deprecation warning"
echo "      (--highlight-style vs --syntax-highlighting)."
echo "      This is harmless and will be fixed when bookdown updates."
echo ""

case "$FORMAT" in
  gitbook)
    Rscript -e "suppressWarnings(bookdown::render_book('index.Rmd', 'bookdown::gitbook'))"
    ;;
  pdf)
    Rscript -e "suppressWarnings(bookdown::render_book('index.Rmd', 'bookdown::pdf_book'))"
    ;;
  epub)
    Rscript -e "suppressWarnings(bookdown::render_book('index.Rmd', 'bookdown::epub_book'))"
    ;;
  all)
    echo "Building gitbook..."
    Rscript -e "suppressWarnings(bookdown::render_book('index.Rmd', 'bookdown::gitbook'))"
    echo "Building PDF..."
    Rscript -e "suppressWarnings(bookdown::render_book('index.Rmd', 'bookdown::pdf_book'))"
    echo "Building EPUB..."
    Rscript -e "suppressWarnings(bookdown::render_book('index.Rmd', 'bookdown::epub_book'))"
    ;;
  *)
    echo "Unknown format: $FORMAT"
    echo "Usage: $0 [gitbook|pdf|epub|all]"
    exit 1
    ;;
esac

# Move outputs to docs/ for GitHub Pages
mkdir -p docs

case "$FORMAT" in
  gitbook)
    # For gitbook, move all HTML files to docs/
    rm -rf docs/*
    mv _book/* docs/
    # Disable Jekyll processing on GitHub Pages
    touch docs/.nojekyll
    ;;
  pdf)
    # For PDF, copy to docs/ (keep in _book/ too)
    cp _book/tech-interview.pdf docs/
    echo "PDF created: docs/tech-interview.pdf"
    ;;
  epub)
    # For EPUB, copy to docs/ (keep in _book/ too)
    cp _book/tech-interview.epub docs/
    echo "EPUB created: docs/tech-interview.epub"
    ;;
  all)
    # For all formats, move everything
    rm -rf docs/*
    mv _book/* docs/
    # Disable Jekyll processing on GitHub Pages
    touch docs/.nojekyll
    echo "All formats created in docs/"
    ;;
esac

echo ""

# Calculate and display elapsed time
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
MINUTES=$((ELAPSED / 60))
SECONDS=$((ELAPSED % 60))
echo "========================================="
if [ $MINUTES -gt 0 ]; then
    echo "⏱  Build time: ${MINUTES}m ${SECONDS}s"
else
    echo "⏱  Build time: ${SECONDS}s"
fi
echo "========================================="
