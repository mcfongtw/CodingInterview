import os

files = [
    "07-linked-list-02-leetcode.Rmd",
    "03-array-04-others.Rmd",
    "03-array-02-leetcode.Rmd",
    "07-linked-list-03-hackerrank.Rmd",
    "03-array-03-hackerrank.Rmd",
    "10-string-manipulation-02-leetcode.Rmd",
    "10-string-manipulation-03-hackerrank.Rmd"
]

for file_path in files:
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            content = f.read()
        
        new_content = content.replace("glossary-of-algorithm.html#two-pointers", "glossary-of-algorithm.html#two-pointer")
        
        if content != new_content:
            with open(file_path, 'w') as f:
                f.write(new_content)
            print(f"Updated {file_path}")
        else:
            print(f"No changes in {file_path}")
    else:
        print(f"File not found: {file_path}")
