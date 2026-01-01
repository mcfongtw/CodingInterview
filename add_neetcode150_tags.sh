#!/bin/bash

# NeetCode 150 problem IDs
NEETCODE150_IDS=(1 2 3 4 5 7 10 11 15 17 19 20 21 22 23 25 33 36 39 40 42 43 45 46 48 49 50 51 53 54 55 56 57 62 66 70 72 73 74 76 78 79 84 90 91 97 98 100 102 104 105 110 115 121 124 125 127 128 130 131 133 134 136 138 139 141 143 146 150 152 153 155 167 190 191 198 199 200 202 206 207 208 210 211 212 213 215 217 226 230 235 238 239 242 252 253 261 268 269 271 286 287 295 297 300 309 312 322 323 329 332 338 347 355 371 416 417 424 435 494 518 543 567 572 621 647 678 684 695 703 704 739 743 746 763 778 787 846 853 875 973 981 994 1046 1143 1448 1584 1851 1899 2013)

# Convert to associative array for O(1) lookup
declare -A neetcode150_set
for id in "${NEETCODE150_IDS[@]}"; do
    neetcode150_set[$id]=1
done

# Process each *-02-leetcode.Rmd file
for file in *-02-leetcode.Rmd; do
    echo "Processing $file..."

    # Create a temporary file
    tmpfile=$(mktemp)

    # Read the file line by line
    in_metadata=0
    problem_id=""

    while IFS= read -r line; do
        # Check if we're starting metadata section
        if [[ "$line" =~ ^###\ Problem\ Metadata ]]; then
            in_metadata=1
            problem_id=""
            echo "$line" >> "$tmpfile"
            continue
        fi

        # Extract Problem ID
        if [[ $in_metadata -eq 1 ]] && [[ "$line" =~ ^-\ \*\*Problem\ ID\*\*:\ ([0-9]+) ]]; then
            problem_id="${BASH_REMATCH[1]}"
            echo "$line" >> "$tmpfile"
            continue
        fi

        # Process Interview Tags line
        if [[ $in_metadata -eq 1 ]] && [[ "$line" =~ ^-\ \*\*Interview\ Tags\*\*: ]]; then
            # Check if this problem is in NeetCode 150
            if [[ -n "${neetcode150_set[$problem_id]}" ]]; then
                current_tags="${line#*: }"

                # Skip if already has NeetCode 150
                if [[ "$current_tags" =~ NeetCode\ 150 ]]; then
                    echo "$line" >> "$tmpfile"
                else
                    # Add NeetCode 150 to tags
                    if [[ -z "$current_tags" ]]; then
                        echo "- **Interview Tags**: NeetCode 150" >> "$tmpfile"
                    else
                        echo "- **Interview Tags**: NeetCode 150, $current_tags" >> "$tmpfile"
                    fi
                fi
            else
                echo "$line" >> "$tmpfile"
            fi
            in_metadata=0
            continue
        fi

        # Reset metadata flag if we hit another section
        if [[ "$line" =~ ^### ]] && [[ ! "$line" =~ ^###\ Problem\ Metadata ]]; then
            in_metadata=0
        fi

        echo "$line" >> "$tmpfile"
    done < "$file"

    # Replace original file with updated version
    mv "$tmpfile" "$file"
    echo "Updated $file"
done

echo "Done!"
