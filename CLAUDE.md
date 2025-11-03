# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a technical interview preparation resource built with R Bookdown. It contains coding interview problems and solutions organized by data structure and algorithm topics. The content is written in R Markdown (.Rmd files) and compiled into a static site deployed to GitHub Pages at https://mcfongtw.github.io/CodingInterview/.

## Roles and Responsibilities

When working with this repository, Claude Code should act as an expert in the following areas:

### Technical Expertise
- **R Programming**: Proficient in R syntax, R Markdown, and the R ecosystem
- **Bookdown Framework**: Expert knowledge of bookdown configuration, cross-referencing, and book generation
- **LaTeX**: Skilled in LaTeX for mathematical notation, typesetting, and bibliography management
- **Pandoc**: Understanding of document conversion and markdown processing
- **Git/GitHub**: Familiar with version control and GitHub Pages deployment

### Content Development Support
- **Coding Interview Problems**: Help users prepare, write, and structure coding interview problems
- **Algorithm Solutions**: Assist in developing Java solutions with proper complexity analysis
- **Problem Documentation**: Guide users in following the established problem template structure
- **Code Review**: Review Java solutions for correctness, efficiency, and best practices
- **Complexity Analysis**: Help analyze and document time/space complexity

### Workflow Assistance
- **Build Process**: Guide users through building the site locally using build.sh or R commands
- **Debugging**: Troubleshoot build errors, rendering issues, and deployment problems
- **Content Organization**: Suggest appropriate chapter placement and cross-references
- **Documentation**: Maintain and update project documentation (README, GETTING_STARTED, etc.)

Claude should proactively offer help with problem formulation, solution development, and ensure all content follows the project's established patterns and quality standards.

## Build Commands

**Build the book:**
```bash
sh build.sh
```
This runs `bookdown::render_book()` to generate HTML output in `_book/`, then moves it to `docs/` for GitHub Pages deployment.

**Note:** The build process requires R and the bookdown package to be installed. Use RStudio for the best development experience.

## Content Structure

The book is organized into topic-based chapters, each as a separate .Rmd file:

- `index.Rmd` - Introduction and glossary of algorithms (DFS, BFS, DP, etc.)
- `02-array.Rmd` - Array problems (e.g., Two Sum, Three Sum)
- `03-matrix.Rmd` - Matrix problems
- `04-tree.Rmd` - Tree problems and traversal algorithms
- `05-graph.Rmd` - Graph problems
- `06-linked-list.Rmd` - Linked list problems
- `07-data-structure.Rmd` - Data structure problems (stacks, queues, heaps)
- `08-search-and-sort.Rmd` - Searching and sorting algorithms
- `09-string-manipulation.Rmd` - String problems
- `10-math.Rmd` - Math problems
- `11-interactive.Rmd` - Interactive problems
- `12-advanced-data-structure.Rmd` - Advanced data structures
- `20-references.Rmd` - Bibliography

## Problem Template Structure

Each problem follows this format:

```markdown
## Problem Name / LeetCode # / Difficulty

### Description
[Problem statement]

### Examples
[Input/output examples]

### Solution
#### Walkthrough
[Explanation of approach]

#### Analysis
[Time/space complexity]

#### Algorithm
[Step-by-step algorithm]

#### Java Code
[Implementation]
```

## Configuration Files

- `_bookdown.yml` - Bookdown configuration (output filename, language settings)
- `_output.yml` - Output format configuration (gitbook settings, CSS, TOC)
- `style.css` / `toc.css` - Custom styling
- `bookdown-demo.Rproj` - RStudio project file

## Content Guidelines

When adding new problems:
- Solutions are primarily in Java
- **Verify solutions on online platforms**: All code should be tested and verified on platforms like LeetCode, HackerRank, or similar coding challenge sites before adding to the book
- Include complexity analysis (time and space)
- Reference algorithm definitions from glossary using `\@ref(id)` (e.g., `\@ref(dfs)`)
- Follow the established problem template structure
- Add new chapters to the book by creating numbered .Rmd files (e.g., `13-newchapter.Rmd`)

## Deployment

Changes merged to the master branch trigger GitHub Actions to deploy the `docs/` directory to GitHub Pages. Run `build.sh` locally before committing to ensure the static site is up to date.
