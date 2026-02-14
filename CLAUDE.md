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
- `02-array-*.Rmd` - Array problems (split by platform, see Multi-File Chapters below)
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

### Multi-File Chapters

For large chapters with 50+ problems, split by platform to improve maintainability:

**File naming pattern:**
```
{chapter-num}-{topic}-01-intro.Rmd       # Chapter header + algorithm summaries
{chapter-num}-{topic}-02-leetcode.Rmd    # LeetCode problems
{chapter-num}-{topic}-03-hackerrank.Rmd  # HackerRank problems
{chapter-num}-{topic}-04-others.Rmd      # Firecode, Interview, Other platforms
```

**Header level rules:**

- **Intro file (`-01-intro.Rmd`):**
  - Contains `# Chapter Name` (level 1 header, **only once per chapter**)
  - Uses `###` (level 3) for top-level conceptual sections — renders as X.0.1, X.0.2, X.0.3...
  - Uses `####` (level 4) for subsections within a conceptual section
  - Uses `#####` (level 5) for sub-subsections (e.g., variants, implementation details)
  - **Never use `##`** inside intro files — that would create a new numbered problem section (X.1, X.2...)
  - Example content: Iterating Combinations, Kadane's Algorithm, Unbounded Knapsack, N Sum Family Comparison
  - Example hierarchy:
    ```
    # Dynamic Programming and Backtracking       ← chapter title (level 1)
    ### Dynamic Programming {#dynamic-programming}   ← 14.0.1 (level 3)
    #### Memoization (Top-Down) {#dp-memoization}    ← subsection (level 4)
    ##### Unbounded Knapsack Pattern               ← sub-subsection (level 5)
    ### Backtracking Algorithms {#backtracking}   ← 14.0.2 (level 3)
    #### Pattern 1: Choose-Explore-Unchoose        ← subsection (level 4)
    ```

- **Problem files (`-02-leetcode`, `-03-hackerrank`, `-04-others`):**
  - **NO level 1 headers** (`#`) - these would create new chapters
  - Use `##` (level 2) for problem titles
  - Use `###` (level 3) for problem subsections (Metadata, Walkthrough, Analysis, etc.)
  - Results in numbering: X.1, X.2, X.3... (e.g., 2.1 Two Sum, 2.2 Median of Two Sorted Arrays)

**How Bookdown merges files:**
- Files are merged in **lexicographic order** by filename
- The `-01-`, `-02-`, `-03-` prefixes ensure correct merge order
- All `02-array-*.Rmd` files become a single "Chapter 2: Arrays"
- Section numbers increment continuously across merged files

### Anchor naming conventions

- `*-01-intro.Rmd`: anchors start with `intro-` (e.g., `{#intro-n-sum-family}`)
- LeetCode problems: anchors start with `lc-`
- HackerRank problems: anchors start with `hr-`
- Firecode problems: anchors start with `fc-`
- Other/uncategorized problems: anchors start with `other-`
- Actual interview problems: anchors start with `interview-`
- Keep anchor slugs lowercase with hyphens and ensure they match `problems_data.csv`

**Result:** Clear visual hierarchy where X.0.* sections are foundational concepts, and X.1+ sections are actual problems.

**Example structure (Array chapter):**
```
Chapter 2: Arrays
  2.0.1 Iterating Combinations       (### in 02-array-01-intro.Rmd)
  2.0.2 Kadane's Algorithm           (### in 02-array-01-intro.Rmd)
  2.0.3 Unbounded Knapsack           (### in 02-array-01-intro.Rmd)
  2.0.4 N Sum Family Comparison      (### in 02-array-01-intro.Rmd)
  2.1 Two Sums I                      (## in 02-array-02-leetcode.Rmd)
  2.2 Median of Two Sorted Arrays     (## in 02-array-02-leetcode.Rmd)
  ...
  2.45 Count Elements Greater Avg     (## in 02-array-03-hackerrank.Rmd)
  ...
  2.54 Max Gain                       (## in 02-array-04-others.Rmd)
```

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
- **Categorize by Data Structure**: Place problems by the data structure **central to the solution's correctness**, not the input type or algorithm label:
  - The input format (e.g., `int[]`, `int[][]`) is not a categorization signal — it is just raw input.
  - Ask: *"Would a reader studying this data structure expect to find this problem here?"*
  - If the problem is trivially solvable without the data structure, it likely does not belong in that chapter.
  - Examples:
    - Last Stone Weight (`int[]` input, max heap solution) → `09-heap.Rmd` — heap is the core insight
    - Course Schedule (`int[][]` input, topological sort solution) → `05-graph.Rmd` — graph traversal is the core insight
    - Linked list sorting → `06-linked-list.Rmd` (not search-and-sort) — linked list manipulation is the core insight
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
