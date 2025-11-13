#!/usr/bin/env python3
"""
Rebuild problems_data.csv to contain ONLY problems that exist in .Rmd files
"""

import re
import csv
from pathlib import Path

# Read existing CSV to get metadata
csv_data = {}
with open('problems_data.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        anchor = row['anchor']
        csv_data[anchor] = row

# Chapter files to process
chapters = [
    ('02-array.Rmd', 'Array', '02'),
    ('03-matrix.Rmd', 'Matrix', '03'),
    ('04-tree.Rmd', 'Tree', '04'),
    ('05-graph.Rmd', 'Graph', '05'),
    ('06-linked-list.Rmd', 'Linked List', '06'),
    ('07-data-structure.Rmd', 'Data Structure', '07'),
    ('08-search-and-sort.Rmd', 'Search and Sort', '08'),
    ('09-string-manipulation.Rmd', 'String Manipulation', '09'),
    ('10-math.Rmd', 'Math', '10'),
    ('11-interactive.Rmd', 'Interactive', '11'),
    ('12-advanced-data-structure.Rmd', 'Advanced Data Structure', '12'),
]

# Pattern to match problem headers: ## Title {#anchor}
header_pattern = re.compile(r'^## (.+?) \{#(.+?)\}$')

# Collect all actual problems
actual_problems = []

for rmd_file, chapter_name, chapter_num in chapters:
    filepath = Path(rmd_file)
    if not filepath.exists():
        print(f"Warning: {rmd_file} not found")
        continue

    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            match = header_pattern.match(line.strip())
            if match:
                title = match.group(1)
                anchor = match.group(2)

                # Try to find this problem in the CSV
                if anchor in csv_data:
                    # Use existing metadata
                    row = csv_data[anchor]
                    actual_problems.append({
                        'title': row['title'],
                        'platform': row['platform'],
                        'problem_id': row['problem_id'],
                        'difficulty': row['difficulty'],
                        'chapter': row['chapter'],
                        'chapter_num': row['chapter_num'],
                        'anchor': anchor
                    })
                else:
                    # Problem exists in .Rmd but not in CSV - use defaults
                    print(f"Warning: New problem found in {rmd_file}: {title} ({anchor})")
                    actual_problems.append({
                        'title': title,
                        'platform': 'Unknown',
                        'problem_id': 'NA',
                        'difficulty': 'Unknown',
                        'chapter': chapter_name,
                        'chapter_num': chapter_num,
                        'anchor': anchor
                    })

# Sort by chapter_num and then by order of appearance (stable sort)
actual_problems.sort(key=lambda x: x['chapter_num'])

# Write new CSV
with open('problems_data.csv', 'w', newline='') as f:
    fieldnames = ['title', 'platform', 'problem_id', 'difficulty', 'chapter', 'chapter_num', 'anchor']
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(actual_problems)

print(f"✓ Rebuilt problems_data.csv with {len(actual_problems)} problems")
print(f"\nBreakdown by chapter:")
chapter_counts = {}
for p in actual_problems:
    ch = p['chapter_num']
    chapter_counts[ch] = chapter_counts.get(ch, 0) + 1

for ch in sorted(chapter_counts.keys()):
    print(f"  Chapter {ch}: {chapter_counts[ch]} problems")
