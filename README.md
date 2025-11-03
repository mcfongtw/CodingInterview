# CodingInterview

A technical interview preparation resource built with R Bookdown, containing coding problems and solutions organized by data structures and algorithms.

## Live Site

https://mcfongtw.github.io/CodingInterview/

## Getting Started

For detailed setup instructions, development workflow, and contribution guidelines, see the **[Getting Started Guide](GETTING_STARTED.md)**.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/mcfongtw/CodingInterview.git
cd CodingInterview

# Build the site
sh build.sh

# Preview locally
open docs/index.html  # macOS
start docs/index.html # Windows

# Deploy changes
git add *.Rmd docs/
git commit -m "Your commit message"
git push origin master
```

## Tech Stack

- **R Bookdown** - Static site generator
- **GitBook Theme** - Documentation interface
- **GitHub Pages** - Hosting
- **GitHub Actions** - Automated deployment

## Reference

This project is based on the [bookdown minimal example](https://github.com/rstudio/bookdown).
