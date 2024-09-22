#!/bin/bash

# Declare large_trees variable outside the function
large_trees=0

# Get the top-level directory of the repository
top_level=$(git rev-parse --show-toplevel)

# Function to check for large trees
check_large_trees() {
  local max_items=50
  local sprite_index=0
  local spritesheet="|/-\\"

  # Find directories with more than max_items subfolders or files
  while IFS= read -r dir; do
    item_count=$(find "$dir" -mindepth 1 -maxdepth 1 | wc -l)
    echo "Item count: $item_count"
    if [ "$item_count" -gt "$max_items" ]; then
      echo "Directory '$dir' has $item_count items, which exceeds the limit of $max_items."
      large_trees=$((large_trees + 1))
      echo "Location: $(realpath "$dir")"
    fi
    sprite=${spritesheet:sprite_index:1}
    sprite_index=$((sprite_index + 1))
    sprite_index=$((sprite_index % 4))
    echo "$dir{0,2}  $sprite  qty: $item_count"
    # done < <(git ls-files --others --exclude-standard | grep '/')
  done < <(git diff --cached --name-only --diff-filter=AM | grep '/' | awk -v top_level=$top_level -F/ '{ print $top_level "/" + $1}' | sort -V)

  echo "Large trees found: $large_trees"
  return $large_trees
}

# Check for large trees before adding files
check_large_trees
if [ $large_trees -gt 0 ]; then
  echo "Add aborted."
  echo "qty: \($large_trees\) large trees."
  exit 1
fi

# Run the actual git add and commit commands
git add -A
if [ $? -eq 0 ]; then
  git commit -m "$@"
fi
