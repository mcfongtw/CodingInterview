# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a technical interview preparation resource built with R Bookdown. It contains coding interview problems and solutions organized by data structure and algorithm topics. The content is written in R Markdown (.Rmd files) and compiled into a static site deployed to GitHub Pages at https://mcfongtw.github.io/CodingInterview/.

## Roles and Responsibilities

Claude Code should act as an expert in:

- **R/Bookdown/LaTeX**: R Markdown, bookdown configuration, cross-referencing, mathematical notation
- **Content Development**: Help structure coding interview problems, review Java solutions, analyze complexity
- **Build & Deployment**: Guide through build.sh, troubleshoot errors, GitHub Pages deployment
- **Organization**: Suggest chapter placement, maintain documentation, ensure content follows established patterns

## Build Commands

**Build the book:**
```bash
sh build.sh
```
This runs `bookdown::render_book()` to generate HTML output in `_book/`, then moves it to `docs/` for GitHub Pages deployment.

**Note:** Requires R and bookdown package. Use RStudio for best development experience.

## Content Structure

The book is organized into topic-based chapters as separate .Rmd files:

- `index.Rmd` - Introduction and algorithm glossary (DFS, BFS, DP, etc.)
- `02-array.Rmd` - Array problems
- `03-matrix.Rmd` - Matrix problems
- `04-tree.Rmd` - Tree problems and traversals
- `05-graph.Rmd` - Graph problems
- `06-linked-list.Rmd` - Linked list problems
- `07-stack-and-queue.Rmd` - Stack and queue problems
- `08-heap.Rmd` - Heap and priority queue problems
- `09-string-manipulation.Rmd` - String problems
- `10-math.Rmd` - Math problems
- `11-interactive.Rmd` - Interactive problems
- `12-advanced-data-structure.Rmd` - Advanced data structures
- `20-references.Rmd` - Bibliography

## Configuration Files

- `_bookdown.yml` - Bookdown configuration (output filename, language)
- `_output.yml` - Output format (gitbook settings, CSS, TOC)
- `style.css` / `toc.css` - Custom styling
- `bookdown-demo.Rproj` - RStudio project file

## Adding New Problems

### Chapter Organization

- **Sort by Platform Priority, Then Problem ID**: Problems must be sorted with the following priority:
  1. LeetCode problems (sorted by problem ID, ascending)
  2. HackerRank problems (sorted by problem ID, ascending)
  3. Other platform problems (sorted by problem ID if available, otherwise by title)
  4. Problems without IDs appear at the end
- **Categorize by Data Structure**: Place problems by primary data structure, not algorithm type:
  - Linked list sorting → `06-linked-list.Rmd` (not search-and-sort)
  - Heap-based → `08-heap.Rmd`
  - Stack/Queue → `07-stack-and-queue.Rmd`

### Two-Phase Workflow

**Phase 1: Structure Creation (Claude)**

When adding a new problem, Claude will:

1. **Fetch problem details** from the platform (LeetCode, HackerRank, etc.)
2. **Insert problem in correct position** following platform priority (LeetCode → HackerRank → Others) and ID order
3. **Create problem section** in appropriate chapter with:
   - Metadata: Platform, ID, Difficulty, URL, Tags, Techniques
   - **Tags**: Company names (`Google`, `Amazon`, `Meta`) and study plans (`Top 100 Liked`, `Blind 75`, `NeetCode 150`)
   - **Techniques**: Use cross-references (e.g., `[Hash Table](\@ref(hash-table))`)
   - Complete description, examples, and constraints
   - Empty solution structure (Walkthrough, Analysis, Implementation Steps, Java Code placeholders)
4. **Assign unique anchor ID** (e.g., `{#min-steps-anagram}`)
5. **Update problems_data.csv** simultaneously with matching anchor and metadata:
   ```csv
   title,platform,problem_id,difficulty,chapter,chapter_num,anchor,tags
   Problem Name,LeetCode,1347,Medium,String Manipulation,09,anchor-id,"Google, Top 100 Liked"
   Problem Name,HackerRank,unique-paths,Easy,Array,02,hr-unique-paths,""
   ```
   **Supported platforms**: `LeetCode`, `HackerRank`, `Other`, `Firecode`, `Interview`
6. **Do NOT implement the solution** - User will fill in placeholders

**Phase 2: Review & Optimization (User + Claude)**

After user implements the solution:
- User verifies solution on the platform
- User requests review
- Claude reviews correctness, efficiency, complexity analysis, and suggests optimizations

### Content Requirements

- Solutions in Java, verified on online platforms (LeetCode, HackerRank, etc.)
- Include time/space complexity analysis
- Use `\@ref(id)` for glossary references (e.g., `\@ref(dfs)`)
- Follow established problem template structure

### R Markdown Gotchas

**CRITICAL: Escape Comparison Operators**

R Markdown has issues with comparison operators (`=`, `<=`, `>=`, `==`) in regular text. Use LaTeX math mode or avoid backticks around these operators.

❌ **WRONG** - Will fail with parsing errors:
```markdown
- While left pointer <= right pointer, compare...
- Initialize two pointers: `l = 0`, `r = chars.length - 1`
```

✅ **CORRECT** - Use LaTeX math notation or descriptive text:
```markdown
- While left pointer $\le$ right pointer, compare...
- Initialize two pointers: left pointer at 0, right pointer at chars.length - 1
```

**Rules**:
1. Use LaTeX math mode for comparison operators: `$\le$`, `$\ge$`, `$\eq$`
2. When documenting variable initialization, avoid backticks around assignments
3. Remove backticks from expressions containing comparison operators

## Deployment

Changes merged to master trigger GitHub Actions to deploy `docs/` to GitHub Pages. Run `build.sh` locally before committing to ensure the static site is up to date.