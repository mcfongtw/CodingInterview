#!/usr/bin/env python3
"""
Script to split 02-array.Rmd into 4 files based on platform.
"""

import csv
import re

# Read the CSV file to get anchor-to-platform mapping for Array problems
def read_csv_mappings(csv_path):
    """Returns dict: {anchor: platform} for Array chapter problems"""
    mappings = {}
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            if row['chapter_num'] == '02' and row['anchor']:
                mappings[row['anchor']] = row['platform']
    return mappings

# Read the entire Rmd file
def read_rmd_file(rmd_path):
    """Returns list of lines from the Rmd file"""
    with open(rmd_path, 'r', encoding='utf-8') as f:
        return f.readlines()

# Extract sections based on ## headers and their anchors
def parse_sections(lines):
    """
    Parse the file into sections.
    Returns: list of dicts with 'start_line', 'end_line', 'header', 'anchor'
    """
    sections = []
    current_section = None

    # Pattern to match: ## Title {#anchor}
    header_pattern = re.compile(r'^## (.+?)\s*\{#(.+?)\}\s*$')

    for i, line in enumerate(lines):
        match = header_pattern.match(line)
        if match:
            # Save previous section
            if current_section:
                current_section['end_line'] = i - 1
                sections.append(current_section)

            # Start new section
            title = match.group(1)
            anchor = match.group(2)
            current_section = {
                'start_line': i,
                'end_line': None,
                'header': line.strip(),
                'title': title,
                'anchor': anchor
            }

    # Close last section
    if current_section:
        current_section['end_line'] = len(lines) - 1
        sections.append(current_section)

    return sections

# Main splitting logic
def split_file():
    csv_path = '/Users/michael.fong/dev/github/mcfongtw/CodingInterview/problems_data.csv'
    rmd_path = '/Users/michael.fong/dev/github/mcfongtw/CodingInterview/02-array.Rmd'

    # Read mappings
    anchor_to_platform = read_csv_mappings(csv_path)
    print(f"Found {len(anchor_to_platform)} Array problems in CSV")

    # Read file
    lines = read_rmd_file(rmd_path)
    print(f"Read {len(lines)} lines from {rmd_path}")

    # Parse sections
    sections = parse_sections(lines)
    print(f"Found {len(sections)} sections with ## headers")

    # Categorize sections by platform
    intro_sections = []
    leetcode_sections = []
    hackerrank_sections = []
    other_sections = []
    nsum_section = None

    for section in sections:
        anchor = section['anchor']

        # Special handling for n-sum-family intro anchor
        if anchor in {'n-sum-family', 'intro-n-sum-family'}:
            nsum_section = section
            continue

        # Check if it's in the CSV
        if anchor in anchor_to_platform:
            platform = anchor_to_platform[anchor]
            if platform == 'LeetCode':
                leetcode_sections.append(section)
            elif platform == 'HackerRank':
                hackerrank_sections.append(section)
            elif platform in ['Firecode', 'Interview', 'Other']:
                other_sections.append(section)
            else:
                print(f"WARNING: Unknown platform '{platform}' for anchor {anchor}")
        else:
            print(f"WARNING: Anchor '{anchor}' not found in CSV")

    print(f"\nCategorized sections:")
    print(f"  LeetCode: {len(leetcode_sections)}")
    print(f"  HackerRank: {len(hackerrank_sections)}")
    print(f"  Other (Firecode/Interview/Other): {len(other_sections)}")
    print(f"  N Sum Family section: {'Found' if nsum_section else 'NOT FOUND'}")

    # Write intro file (lines 1-216 + N Sum Family section with ## -> ### conversion)
    intro_path = '/Users/michael.fong/dev/github/mcfongtw/CodingInterview/02-array-01-intro.Rmd'
    with open(intro_path, 'w', encoding='utf-8') as f:
        # Lines 1-216 (0-indexed: 0-215)
        for i in range(0, 216):
            line = lines[i]
            # Replace ## with ### for these specific sections
            if line.startswith('## Iterating Combinations') or \
               line.startswith('## Kadane\'s Algorithm') or \
               line.startswith('## Unbounded Knapsack'):
                line = line.replace('## ', '### ', 1)
            f.write(line)

        # Add N Sum Family section with ## -> ### conversion
        if nsum_section:
            f.write('\n')
            start = nsum_section['start_line']
            end = nsum_section['end_line']
            for i in range(start, end + 1):
                line = lines[i]
                # Replace ## with ### for the main header
                if i == start:
                    line = line.replace('## ', '### ', 1)
                f.write(line)

    print(f"\nCreated: {intro_path}")

    # Write LeetCode problems file
    leetcode_path = '/Users/michael.fong/dev/github/mcfongtw/CodingInterview/02-array-02-leetcode.Rmd'
    with open(leetcode_path, 'w', encoding='utf-8') as f:
        for section in leetcode_sections:
            start = section['start_line']
            end = section['end_line']
            for i in range(start, end + 1):
                f.write(lines[i])
            f.write('\n')  # Add blank line between problems

    print(f"Created: {leetcode_path}")

    # Write HackerRank problems file
    hackerrank_path = '/Users/michael.fong/dev/github/mcfongtw/CodingInterview/02-array-03-hackerrank.Rmd'
    with open(hackerrank_path, 'w', encoding='utf-8') as f:
        for section in hackerrank_sections:
            start = section['start_line']
            end = section['end_line']
            for i in range(start, end + 1):
                f.write(lines[i])
            f.write('\n')  # Add blank line between problems

    print(f"Created: {hackerrank_path}")

    # Write Other problems file
    other_path = '/Users/michael.fong/dev/github/mcfongtw/CodingInterview/02-array-04-others.Rmd'
    with open(other_path, 'w', encoding='utf-8') as f:
        for section in other_sections:
            start = section['start_line']
            end = section['end_line']
            for i in range(start, end + 1):
                f.write(lines[i])
            f.write('\n')  # Add blank line between problems

    print(f"Created: {other_path}")

    print("\n=== SUMMARY ===")
    print(f"Total sections processed: {len(leetcode_sections) + len(hackerrank_sections) + len(other_sections)}")
    print(f"Intro file: Lines 1-216 + N Sum Family (with ## -> ###)")
    print(f"LeetCode: {len(leetcode_sections)} problems")
    print(f"HackerRank: {len(hackerrank_sections)} problems")
    print(f"Others: {len(other_sections)} problems")

if __name__ == '__main__':
    split_file()
