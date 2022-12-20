#!/usr/bin/env bash
# This is experimental. 

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
cd "$PROJECT_DIR" || exit 1

# Set the maximum size in bytes
max_size=40000000 # 40 MB

# Initialize the total size to 0
total_size=0

# shellcheck disable=SC2044
for file in $(find . -type f); do
  # Get the size of the file in bytes
  file_size=$(wc -c <"$file")

  # Add the file size to the total size
  total_size=$((total_size + file_size))

  if [ $total_size -gt $max_size ]; then
    # If git staged file size is greater than zero, commit the files
    if [ "$(git diff --cached --numstat | wc -l)" -gt 0 ]; then
      git commit --message "$total_size"
      git push
      total_size=0
    fi
  else
    git add "$file"
  fi
done

git commit --message "$total_size"
git push
