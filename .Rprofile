# R profile for CodingInterview book
# This file is automatically loaded when R starts in this directory

# Increase Pandoc stack size from default 512m to 1024m for better performance
options(
  pandoc.stack.size = "1024m"
)

# Set Pandoc arguments for all output formats
.env <- environment()
.env$pandoc_args_stack <- c("+RTS", "-K1024m", "-RTS")