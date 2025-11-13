# Getting Started Guide

This guide will help you set up your development environment and contribute to the CodingInterview project.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Tech Stack](#tech-stack)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Building the Site](#building-the-site)
6. [Adding New Content](#adding-new-content)
7. [Deploying Changes](#deploying-changes)
8. [Troubleshooting](#troubleshooting)

---

## Project Overview

This is a technical interview preparation resource built with R Bookdown. It contains coding interview problems and solutions organized by data structure and algorithm topics.

- **Live Site**: https://mcfongtw.github.io/CodingInterview/
- **GitHub Repository**: https://github.com/mcfongtw/CodingInterview
- **License**: CC0 1.0 Universal (Public Domain)

### Project Structure

```
CodingInterview/
├── index.Rmd                  # Introduction & Algorithm Glossary
├── 02-array.Rmd              # Array problems
├── 03-matrix.Rmd             # Matrix problems
├── 04-tree.Rmd               # Tree problems
├── 05-graph.Rmd              # Graph problems
├── 06-linked-list.Rmd        # Linked list problems
├── 07-data-structure.Rmd     # Data structure problems
├── 08-search-and-sort.Rmd    # Search & sort algorithms
├── 09-string-manipulation.Rmd # String problems
├── 10-math.Rmd               # Math problems
├── 11-interactive.Rmd        # Interactive problems
├── 12-advanced-data-structure.Rmd # Advanced data structures
├── 20-references.Rmd         # Bibliography
├── _bookdown.yml             # Bookdown configuration
├── _output.yml               # Output format settings
├── build.sh                  # Build script
├── docs/                     # Generated static site (deployed to GitHub Pages)
├── latex/                    # LaTeX support files
└── style.css                 # Custom styling
```

---

## Tech Stack

### Core Technologies

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Framework** | R Bookdown | Static site generator for technical documentation |
| **Content Format** | R Markdown (.Rmd) | Markdown with code chunks and LaTeX support |
| **Solution Language** | Java | All algorithm implementations |
| **Theme** | GitBook 2.6.7 | Interactive documentation interface |
| **Deployment** | GitHub Pages | Free static site hosting |
| **CI/CD** | GitHub Actions | Automated deployment workflow |

### Supporting Tools

- **R**: Programming language runtime (v3.6+ recommended)
- **RStudio**: IDE for R Markdown development (recommended)
- **Pandoc**: Document conversion engine (v1.19+)
- **Git**: Version control
- **Bookdown**: R package for book generation
- **knitr**: R package for dynamic report generation

---

## Prerequisites

### Required Software

#### 1. R (Version 3.6 or higher)

**Windows**:
```bash
# Download installer from: https://cran.r-project.org/bin/windows/base/
# OR use Chocolatey:
choco install r.project
```

**macOS**:
```bash
# Download installer from: https://cran.r-project.org/bin/macosx/
# OR use Homebrew:
brew install r
```

**Linux (Ubuntu/Debian)**:
```bash
sudo apt-get update
sudo apt-get install r-base r-base-dev
```

#### 2. RStudio (Recommended)

Download from: https://posit.co/download/rstudio-desktop/

RStudio provides:
- Integrated R Markdown editor
- Live preview
- Built-in Pandoc
- Package management UI

#### 3. Git

**Windows**:
```bash
# Download from: https://git-scm.com/download/win
# OR use Chocolatey:
choco install git
```

**macOS**:
```bash
brew install git
```

**Linux**:
```bash
sudo apt-get install git
```

### Required R Packages

After installing R, open R console or RStudio and run:

```r
# Install required packages
install.packages("bookdown")
install.packages("knitr")
install.packages("rmarkdown")

# Optional but recommended for additional features
install.packages("magick")      # Image manipulation
install.packages("pdftools")    # PDF support
```

**Verify installation**:
```r
library(bookdown)
library(knitr)
library(rmarkdown)
```

If no errors appear, you're ready to go!

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/mcfongtw/CodingInterview.git
cd CodingInterview
```

### 2. Verify File Structure

Ensure you have these key files:
```bash
# Check configuration files
ls _bookdown.yml _output.yml build.sh

# Check content files
ls *.Rmd
```

### 3. Open in RStudio (Recommended)

1. Open RStudio
2. File → Open Project
3. Navigate to `CodingInterview` folder
4. Select `bookdown-demo.Rproj`

---

## Building the Site

There are three ways to build the site:

### Method 1: Using build.sh (Recommended for Linux/macOS/Git Bash)

```bash
# From project root directory
sh build.sh
```

**What this does**:
1. Runs `bookdown::render_book('index.Rmd', 'bookdown::gitbook')`
2. Generates HTML files in `_book/` directory
3. Clears `docs/` directory
4. Moves `_book/` contents to `docs/` for GitHub Pages deployment

### Method 2: Using RStudio

1. Open `bookdown-demo.Rproj` in RStudio
2. In the RStudio console, run:
   ```r
   bookdown::render_book('index.Rmd', 'bookdown::gitbook')
   ```
3. Manually move files:
   - Delete contents of `docs/`
   - Copy all files from `_book/` to `docs/`

### Method 3: Using PowerShell (Windows)

```powershell
# From project root directory
cd "C:\Users\YourName\dev\CodingInterview"

# Build the book
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

# Move files to docs/
Remove-Item -Recurse -Force docs\*
Move-Item -Force _book\* docs\
```

### Verify Build Success

After building, check that:
```bash
# docs/ should contain HTML files
ls docs/index.html
ls docs/libs/gitbook-2.6.7/

# Preview locally (open in browser)
open docs/index.html  # macOS
start docs/index.html # Windows
xdg-open docs/index.html # Linux
```

---

## Adding New Content

### Content Structure

Each problem follows this template:

```markdown
## Problem Title {#problem-id}

### Problem Metadata

- **Platform**: [LeetCode/HackerRank/Other]
- **Problem ID**: [Number]
- **Difficulty**: [Easy/Medium/Hard]
- **URL**: [Direct link to problem]
- **Tags**: [Keywords for searching]
- **Techniques**: [Links to glossary using \@ref(technique)]

### Description

[Problem statement - describe what needs to be solved]

### Examples

**Example 1:**
```
Input: [input]
Output: [output]
Explanation: [why]
```

### Constraints

- [List constraints from problem]

### Solution

#### Walkthrough

[Explain the approach and thought process]

#### Analysis

- **Time Complexity**: O(?)
- **Space Complexity**: O(?)

#### Algorithm

1. Step 1
2. Step 2
3. Step 3

#### Java Code

```java
public class Solution {
    public ReturnType methodName(InputType input) {
        // Implementation
    }
}
```
```

### Adding a New Problem to Existing Chapter

1. Open the relevant `.Rmd` file (e.g., `02-array.Rmd` for array problems)
2. Add your problem following the template above
3. Reference algorithm definitions from glossary using `\@ref(dfs)`, `\@ref(bfs)`, etc.
4. Save the file
5. Build the site (see [Building the Site](#building-the-site))
6. Preview in `docs/` directory

### Adding a New Chapter

1. Create a new `.Rmd` file with appropriate numbering (e.g., `13-dynamic-programming.Rmd`)
2. Add YAML header if needed:
   ```markdown
   # Dynamic Programming

   [Introduction to the topic...]

   ## Problem 1
   [Content...]
   ```
3. The file will automatically be included in the next build
4. Build the site
5. Verify the new chapter appears in the table of contents

### Referencing Algorithms

Use cross-references to link to glossary definitions in `index.Rmd`:

```markdown
This problem uses Depth First Search \@ref(dfs) and Binary Search \@ref(binary-search).
```

Available references:
- `\@ref(dfs)` - Depth First Search
- `\@ref(bfs)` - Breadth First Search
- `\@ref(topological)` - Topological Sorting

---

## Deploying Changes

### Deployment Overview

The project uses GitHub Pages for hosting. The deployment workflow is:

```
Local Development → Build → Commit → Push → GitHub Actions → Live Site
```

### Step-by-Step Deployment

#### 1. Build the Site Locally

**IMPORTANT**: You MUST build locally before committing!

```bash
sh build.sh
```

This generates the static HTML files in `docs/` directory.

#### 2. Verify Changes

Preview the built site:
```bash
# Open in browser
open docs/index.html
```

Check:
- ✅ New content appears correctly
- ✅ Navigation works
- ✅ Code highlighting is correct
- ✅ Cross-references resolve
- ✅ No broken links

#### 3. Commit Changes

```bash
# Check what changed
git status

# Add source files (.Rmd) and generated files (docs/)
git add *.Rmd docs/

# Create commit
git commit -m "Add [Problem Name] solution"
```

**Commit Message Guidelines**:
- `Add [Problem Name] solution` - New problem
- `Update [Problem Name] - fix typo` - Bug fix
- `Refactor [Chapter Name] structure` - Restructuring
- `Update README` - Documentation

#### 4. Push to GitHub

```bash
git push origin master
```

#### 5. Monitor Deployment

1. Go to: https://github.com/mcfongtw/CodingInterview/actions
2. Find your commit in "Deploy static content to Pages" workflow
3. Wait for green checkmark (usually 1-2 minutes)
4. Visit: https://mcfongtw.github.io/CodingInterview/

**Note**: GitHub Pages may take an additional 1-2 minutes for DNS propagation.

### GitHub Actions Workflow

The deployment is automated via `.github/workflows/gh-page-deployment.yml`:

```yaml
on:
  push:
    branches: ["master"]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - Checkout code
      - Setup GitHub Pages
      - Upload docs/ directory
      - Deploy to GitHub Pages
```

**Key Points**:
- Triggers on every push to `master` branch
- Deploys content from `docs/` directory (NOT built by CI)
- Manual builds required before pushing
- No server-side rendering

---

## Troubleshooting

### Build Issues

#### Error: "there is no package called 'bookdown'"

**Solution**: Install the package
```r
install.packages("bookdown")
```

#### Error: "pandoc not found"

**Solution**:
- If using RStudio: Pandoc is bundled, restart RStudio
- If using R from terminal: Install Pandoc separately
  ```bash
  # Windows
  choco install pandoc

  # macOS
  brew install pandoc

  # Linux
  sudo apt-get install pandoc
  ```

#### Error: build.sh permission denied

**Solution** (Linux/macOS):
```bash
chmod +x build.sh
sh build.sh
```

#### Windows: "sh: command not found"

**Solutions**:
1. Use Git Bash (comes with Git for Windows)
2. Use PowerShell method (see [Building the Site](#building-the-site))
3. Use RStudio method

### Content Issues

#### Cross-references not working

**Problem**: Link shows `??` instead of section number

**Solution**:
- Ensure target section has `{#id}` label
- Example: `### Depth First Traversal {#dfs}`
- Reference with `\@ref(dfs)`

#### Code not highlighting correctly

**Problem**: Java code appears as plain text

**Solution**:
- Ensure code block has language specified:
  ````markdown
  ```java
  public class Solution {
      // code
  }
  ```
  ````

#### New chapter not appearing

**Solution**:
- Check file naming: Must follow pattern `##-chapter-name.Rmd` (e.g., `13-dp.Rmd`)
- Ensure file is in root directory, not subdirectory
- Rebuild completely: Delete `_book/` and `docs/`, then rebuild

### Deployment Issues

#### Site not updating after push

**Checklist**:
1. Did you run `build.sh` locally? ✅
2. Did you commit `docs/` directory? ✅
3. Did GitHub Actions workflow succeed? ✅
4. Have you waited 2-3 minutes? ✅

**Solution**:
- Check Actions tab: https://github.com/mcfongtw/CodingInterview/actions
- If workflow failed, check error logs
- If workflow succeeded, clear browser cache and try again

#### 404 Error on GitHub Pages

**Solution**:
- Verify GitHub Pages settings:
  1. Go to repository Settings → Pages
  2. Source should be "GitHub Actions"
  3. Check that `docs/index.html` exists in your repository

#### Changes appear locally but not on live site

**Common Cause**: Forgot to commit `docs/` directory

**Solution**:
```bash
git add docs/
git commit -m "Update built site"
git push origin master
```

### File Path Issues (Windows)

**Problem**: File modification errors on Windows

**Solution**: Use complete absolute paths with drive letters and backslashes:
```
# Good
C:\Users\Michael Fong\dev\CodingInterview\02-array.Rmd

# Bad
./02-array.Rmd
```

---

## Quick Reference

### Common Commands

```bash
# Build site
sh build.sh

# Build in R console
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

# Preview locally
open docs/index.html

# Check git status
git status

# Deploy workflow
git add *.Rmd docs/
git commit -m "Your message"
git push origin master
```

### Important Files

| File | Purpose |
|------|---------|
| `_bookdown.yml` | Bookdown configuration (output filename, language) |
| `_output.yml` | GitBook theme settings, CSS, TOC configuration |
| `build.sh` | Automated build script |
| `index.Rmd` | Introduction + algorithm glossary |
| `##-*.Rmd` | Chapter files (numbered) |
| `docs/` | Generated site (deployed to GitHub Pages) |
| `style.css` | Custom styling |

### Useful Links

- **Live Site**: https://mcfongtw.github.io/CodingInterview/
- **Repository**: https://github.com/mcfongtw/CodingInterview
- **GitHub Actions**: https://github.com/mcfongtw/CodingInterview/actions
- **Bookdown Documentation**: https://bookdown.org/yihui/bookdown/
- **R Markdown Guide**: https://rmarkdown.rstudio.com/
- **GitBook Theme**: https://github.com/rstudio/bookdown

---

## Development Workflow Summary

### For New Contributors

1. **Setup** (one-time):
   ```bash
   # Install R, RStudio, Git
   # Install R packages: bookdown, knitr, rmarkdown
   git clone https://github.com/mcfongtw/CodingInterview.git
   ```

2. **Add Content**:
   - Edit `.Rmd` files
   - Follow problem template
   - Use cross-references for algorithms

3. **Build & Test**:
   ```bash
   sh build.sh
   open docs/index.html  # Preview
   ```

4. **Deploy**:
   ```bash
   git add *.Rmd docs/
   git commit -m "Add XYZ problem"
   git push origin master
   ```

5. **Verify**:
   - Check GitHub Actions (1-2 min)
   - Visit live site (wait 2-3 min)

### For Maintainers

- Content is in `.Rmd` files (source of truth)
- `docs/` is generated (don't edit manually)
- Always build locally before committing
- GitHub Actions only deploys, doesn't build
- Site deploys from `master` branch automatically

---

## Contributing Guidelines

1. **One problem per commit** - Makes review easier
2. **Follow the template** - Consistent structure helps readers
3. **Verify solutions on coding platforms** - Test and verify all Java solutions on LeetCode, HackerRank, or similar platforms before adding to the book
4. **Test locally first** - Always preview in `docs/` before pushing
5. **Include complexity analysis** - Time and space complexity required
6. **Add cross-references** - Link to algorithm glossary when applicable
7. **Use meaningful commit messages** - Describe what was added/changed
8. **Keep solutions in Java** - Maintain language consistency

---

## Need Help?

- **Bookdown Issues**: Check [Bookdown documentation](https://bookdown.org/yihui/bookdown/)
- **R Markdown Syntax**: See [R Markdown Guide](https://rmarkdown.rstudio.com/)
- **GitHub Pages**: Visit [GitHub Pages docs](https://docs.github.com/en/pages)
- **Project Questions**: Open an issue at https://github.com/mcfongtw/CodingInterview/issues

---

**Happy Coding!** 🚀
