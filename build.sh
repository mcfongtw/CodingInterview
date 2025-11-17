#!/bin/sh
#
# Build script for Technical Interview book
#
# Usage:
#   sh build.sh [format] [--skip-validation]
#
# Formats:
#   gitbook (default) - HTML for GitHub Pages
#   pdf               - PDF output
#   epub              - EPUB output
#   all               - Build all formats
#
# Options:
#   --skip-validation - Skip source validation (not recommended)
#
# Examples:
#   sh build.sh                    # Build gitbook with validation
#   sh build.sh pdf                # Build PDF with validation
#   sh build.sh all                # Build all formats
#   sh build.sh gitbook --skip-validation  # Build without validation
#

set -e

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
    Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
    ;;
  pdf)
    Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
    ;;
  epub)
    Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
    ;;
  all)
    echo "Building gitbook..."
    Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
    echo "Building PDF..."
    Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
    echo "Building EPUB..."
    Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::epub_book')"
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
