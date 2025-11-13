#!/usr/bin/env Rscript

# Verification script for R Bookdown dependencies
cat("=== Checking R Bookdown Dependencies ===\n\n")

# Check R version
cat("R Version:\n")
print(R.version.string)
cat("\n")

# Required R packages
required_packages <- c(
  "bookdown",
  "knitr",
  "rmarkdown",
  "tinytex",
  "magick",
  "pdftools",
  "htmltools",
  "xfun"
)

# Check each package
cat("Checking R Packages:\n")
all_installed <- TRUE
for (pkg in required_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    version <- as.character(packageVersion(pkg))
    cat(sprintf("  ✓ %s (v%s)\n", pkg, version))
  } else {
    cat(sprintf("  ✗ %s (NOT INSTALLED)\n", pkg))
    all_installed <- FALSE
  }
}
cat("\n")

# Check TinyTeX installation
cat("Checking TinyTeX:\n")
if (requireNamespace("tinytex", quietly = TRUE)) {
  if (tinytex::is_tinytex()) {
    cat("  ✓ TinyTeX is installed\n")

    # Check specific LaTeX packages
    cat("\nChecking LaTeX Packages:\n")
    latex_packages <- c("preview", "pgf", "tikz-cd", "standalone", "xcolor")
    for (pkg in latex_packages) {
      # tinytex doesn't have a direct package check, so we'll just list this as info
      cat(sprintf("  - %s (will be auto-installed if missing)\n", pkg))
    }
  } else {
    cat("  ✗ TinyTeX is NOT installed\n")
    cat("    Run: tinytex::install_tinytex()\n")
    all_installed <- FALSE
  }
} else {
  cat("  ✗ tinytex package not available\n")
  all_installed <- FALSE
}
cat("\n")

# Check system dependencies
cat("Checking System Dependencies:\n")

# Check Pandoc
pandoc_version <- tryCatch({
  rmarkdown::pandoc_version()
}, error = function(e) NULL)

if (!is.null(pandoc_version)) {
  cat(sprintf("  ✓ Pandoc (v%s)\n", pandoc_version))
} else {
  cat("  ✗ Pandoc (NOT FOUND)\n")
  all_installed <- FALSE
}

# Check ImageMagick (via magick package)
if (requireNamespace("magick", quietly = TRUE)) {
  magick_config <- tryCatch({
    magick::magick_config()
    TRUE
  }, error = function(e) FALSE)

  if (magick_config) {
    cat("  ✓ ImageMagick (detected via magick package)\n")
  } else {
    cat("  ✗ ImageMagick (NOT PROPERLY CONFIGURED)\n")
    all_installed <- FALSE
  }
}

# Check poppler (via pdftools package)
if (requireNamespace("pdftools", quietly = TRUE)) {
  poppler_config <- tryCatch({
    pdftools::poppler_config()
    TRUE
  }, error = function(e) FALSE)

  if (poppler_config) {
    cat("  ✓ Poppler (detected via pdftools package)\n")
  } else {
    cat("  ✗ Poppler (NOT PROPERLY CONFIGURED)\n")
    all_installed <- FALSE
  }
}

cat("\n")

# Final status
if (all_installed) {
  cat("=== ✓ ALL DEPENDENCIES INSTALLED ===\n")
  cat("You should be able to run: sh build.sh\n")
  quit(status = 0)
} else {
  cat("=== ✗ MISSING DEPENDENCIES ===\n")
  cat("Please install missing packages before building.\n")
  quit(status = 1)
}
