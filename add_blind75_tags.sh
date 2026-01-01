#!/bin/bash

# Blind 75 problem IDs
BLIND75_IDS=(1 3 5 11 15 19 20 21 23 33 39 48 49 53 54 55 56 57 62 70 73 76 79 91 98 100 102 104 105 121 124 125 128 133 139 141 143 152 153 190 191 198 200 206 207 208 211 212 213 217 226 230 235 238 242 252 253 261 268 269 271 295 297 300 322 323 338 347 371 417 424 435 572 647 1143)

# Convert to associative array for O(1) lookup
declare -A blind75_set
for id in "${BLIND75_IDS[@]}"; do
    blind75_set[$id]=1
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
            # Check if this problem is in Blind 75
            if [[ -n "${blind75_set[$problem_id]}" ]]; then
                current_tags="${line#*: }"

                # Skip if already has Blind 75
                if [[ "$current_tags" =~ Blind\ 75 ]]; then
                    echo "$line" >> "$tmpfile"
                else
                    # Add Blind 75 to tags
                    if [[ -z "$current_tags" ]]; then
                        echo "- **Interview Tags**: Blind 75" >> "$tmpfile"
                    else
                        echo "- **Interview Tags**: Blind 75, $current_tags" >> "$tmpfile"
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
