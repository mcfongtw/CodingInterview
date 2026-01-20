#!/bin/bash

if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./add_interview_tags.sh [--list NAME]... [--all]

Adds interview tag labels to *-02-leetcode.Rmd files based on list membership.

Examples:
  ./add_interview_tags.sh --list blind75
  ./add_interview_tags.sh --list neetcode150 --list grind75
  ./add_interview_tags.sh --all

To add a new list:
  1) Add NAME to AVAILABLE_LISTS.
  2) Add a label to LIST_TAGS.
  3) Add the ID list to LIST_IDS.
EOF
}

AVAILABLE_LISTS=(blind75 neetcode150 grind75)

get_list_label() {
  case "$1" in
    blind75) echo "Blind 75" ;;
    neetcode150) echo "NeetCode 150" ;;
    grind75) echo "Grind 75" ;;
    *) return 1 ;;
  esac
}

get_list_ids() {
  case "$1" in
    blind75) echo "1 3 5 11 15 19 20 21 23 33 39 48 49 53 54 55 56 57 62 70 73 76 79 91 98 100 102 104 105 121 124 125 128 133 139 141 143 152 153 190 191 198 200 206 207 208 211 212 213 217 226 230 235 238 242 252 253 261 268 269 271 295 297 300 322 323 338 347 371 417 424 435 572 647 1143" ;;
    neetcode150) echo "1 2 3 4 5 7 10 11 15 17 19 20 21 22 23 25 33 36 39 40 42 43 45 46 48 49 50 51 53 54 55 56 57 62 66 70 72 73 74 76 78 79 84 90 91 97 98 100 102 104 105 110 115 121 124 125 127 128 130 131 133 134 136 138 139 141 143 146 150 152 153 155 167 190 191 198 199 200 202 206 207 208 210 211 212 213 215 217 226 230 235 238 239 242 252 253 261 268 269 271 286 287 295 297 300 309 312 322 323 329 332 338 347 355 371 416 417 424 435 494 518 543 567 572 621 647 678 684 695 703 704 739 743 746 763 778 787 846 853 875 973 981 994 1046 1143 1448 1584 1851 1899 2013" ;;
    grind75) echo "1 3 5 8 11 15 17 20 21 23 33 39 42 46 53 54 56 57 62 67 70 75 76 78 79 84 98 102 104 105 110 121 125 127 133 139 141 146 150 155 169 199 200 206 207 208 217 224 226 230 232 235 236 238 242 278 295 297 310 322 383 409 416 438 542 543 621 704 721 733 876 973 981 994 1235" ;;
    *) return 1 ;;
  esac
}

selected_lists=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)
      selected_lists+=("${2:-}")
      shift 2
      ;;
    --all)
      selected_lists=("${AVAILABLE_LISTS[@]}")
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ${#selected_lists[@]} -eq 0 ]]; then
  selected_lists=("${AVAILABLE_LISTS[@]}")
fi

for list in "${selected_lists[@]}"; do
  if ! get_list_label "$list" >/dev/null; then
    echo "Unknown list: $list" >&2
    echo "Available lists: ${AVAILABLE_LISTS[*]}" >&2
    exit 1
  fi
done

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

join_by() {
  local IFS="$1"
  shift
  echo "$*"
}

apply_list() {
  local list="$1"
  local list_label
  list_label="$(get_list_label "$list")"
  local list_ids
  list_ids="$(get_list_ids "$list")"

  for file in *-02-leetcode.Rmd; do
    echo "Processing $file for $list_label..."
    tmpfile=$(mktemp)

    in_metadata=0
    problem_id=""

    while IFS= read -r line; do
      if [[ "$line" =~ ^###\ Problem\ Metadata ]]; then
        in_metadata=1
        problem_id=""
        echo "$line" >> "$tmpfile"
        continue
      fi

      if [[ $in_metadata -eq 1 ]] && [[ "$line" =~ ^-\ \*\*Problem\ ID\*\*:\ ([0-9]+) ]]; then
        problem_id="${BASH_REMATCH[1]}"
        echo "$line" >> "$tmpfile"
        continue
      fi

      if [[ $in_metadata -eq 1 ]] && [[ "$line" =~ ^-\ \*\*(Tags|Interview\ Tags)\*\*: ]]; then
        if [[ -n "$problem_id" && " $list_ids " == *" $problem_id "* ]]; then
          if [[ "$line" == *"**Tags**"* ]]; then
            tag_label="- **Tags**"
          else
            tag_label="- **Interview Tags**"
          fi

          current_tags="${line#*: }"
          if [[ "$current_tags" == "$line" ]]; then
            current_tags=""
          fi

          tag_found=0
          if [[ -n "$current_tags" ]]; then
            IFS=',' read -r -a current_parts <<< "$current_tags"
            for part in "${current_parts[@]}"; do
              tag="$(trim "$part")"
              if [[ "$tag" == "$list_label" ]]; then
                tag_found=1
                break
              fi
            done
          fi

          if [[ $tag_found -eq 1 ]]; then
            echo "$line" >> "$tmpfile"
          else
            if [[ -z "$current_tags" ]]; then
              echo "$tag_label: $list_label" >> "$tmpfile"
            else
              echo "$tag_label: $list_label, $current_tags" >> "$tmpfile"
            fi
          fi
        else
          echo "$line" >> "$tmpfile"
        fi

        in_metadata=0
        continue
      fi

      if [[ "$line" =~ ^### ]] && [[ ! "$line" =~ ^###\ Problem\ Metadata ]]; then
        in_metadata=0
      fi

      echo "$line" >> "$tmpfile"
    done < "$file"

    mv "$tmpfile" "$file"
    echo "Updated $file"
  done
}

for list in "${selected_lists[@]}"; do
  apply_list "$list"
done

update_csv_for_list() {
  local list="$1"
  local list_label
  list_label="$(get_list_label "$list")"
  local list_ids
  list_ids="$(get_list_ids "$list")"

  if [[ ! -f problems_data.csv ]]; then
    echo "Skipping problems_data.csv (not found)" >&2
    return
  fi

  LIST_LABEL="$list_label" LIST_IDS="$list_ids" python - <<'PY'
import csv
import os
import tempfile

list_label = os.environ["LIST_LABEL"]
list_ids = set(os.environ["LIST_IDS"].split())

with open("problems_data.csv", newline="") as f:
    reader = csv.DictReader(f)
    fieldnames = reader.fieldnames
    rows = []
    for row in reader:
        problem_id = row.get("problem_id", "")
        if problem_id in list_ids:
            tags = row.get("tags", "") or ""
            parts = [p.strip() for p in tags.split(",") if p.strip()] if tags else []
            if list_label not in parts:
                parts = [list_label] + parts
                row["tags"] = ", ".join(parts)
        rows.append(row)

with tempfile.NamedTemporaryFile("w", delete=False, newline="") as tmp:
    writer = csv.DictWriter(tmp, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)
    tmp_path = tmp.name

os.replace(tmp_path, "problems_data.csv")
PY
}

for list in "${selected_lists[@]}"; do
  update_csv_for_list "$list"
done

echo "Updated problems_data.csv"

echo "Done!"
