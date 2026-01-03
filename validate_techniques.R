#!/usr/bin/env Rscript

# Validate technique anchors in problems_data.csv against an allowed list.

valid_techniques <- c(
  # Dynamic Programming
  "dp-memoization", "dp-tabulation", "dp-unbounded-knapsack", "kadanes-algorithm",
  "dynamic-programming",

  # Backtracking
  "backtracking-choose-explore-unchoose-pattern",
  "backtracking-pass-by-value-pattern",
  "backtracking-mark-unmark-pattern",
  "backtracking",

  # Two Pointer
  "two-pointer", "sliding-window",

  # Data Structures
  "hash-table", "heap", "stack", "queue", "bst", "trie", "linked-list", "array",

  # Traversal
  "dfs", "bfs", "topological",

  # Search/Sort
  "binary-search", "sorting", "ms", "qs", "bs",

  # Paradigms
  "greedy", "dnc", "recursion",

  # Matrix
  "matrix-traversal", "matrix-manipulation",

  # Advanced
  "bitwise", "simulation", "probability", "rejection-sampling",
  "reservoir-sampling", "minimax"
)

problems <- read.csv("problems_data.csv", stringsAsFactors = FALSE)
if (!"techniques" %in% names(problems)) {
  stop("Missing techniques column in problems_data.csv")
}

errors <- c()

for (i in 1:nrow(problems)) {
  techniques_str <- problems$techniques[i]
  if (is.na(techniques_str) || trimws(techniques_str) == "") {
    next
  }

  techs <- unlist(strsplit(techniques_str, ","))
  techs <- trimws(techs)
  techs <- techs[techs != ""]

  invalid <- techs[!(techs %in% valid_techniques)]
  if (length(invalid) > 0) {
    for (tech in invalid) {
      errors <- c(errors, sprintf("Row %d (%s): Invalid technique '%s'", i, problems$title[i], tech))
    }
  }
}

if (length(errors) > 0) {
  cat("VALIDATION FAILED:\n\n")
  cat(paste(errors, collapse = "\n"), "\n\n")
  cat("Valid techniques:\n")
  cat(paste("-", valid_techniques, collapse = "\n"), "\n")
  stop("Technique validation failed")
}

cat("All techniques valid\n")
