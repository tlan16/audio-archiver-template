#!/usr/bin/env bash
# This is experimental.

set -euox pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
cd "$PROJECT_DIR" || exit 1

# Set the maximum size in bytes
max_size=40000000 # 40 MB

# Initialize the total size to 0
total_size=0

# shellcheck disable=SC2044
for file in *.* **/*; do
  if [[ "$file" == *"URLs.txt" ]]; then
    continue
  fi

  # Get the size of the file in bytes
  file_size=$(wc -c <"$file")

  # Add the file size to the total size
  total_size=$((total_size + file_size))

  if [ $total_size -gt $max_size ] && [ -n "$(git status --porcelain)" ]; then
    git commit --message "$total_size"
    git push --force-with-lease
    total_size=0
  else
    git add "$file"
    echo "Added $file"
  fi
done

git add .
if [ -n "$(git status --porcelain)" ]; then
  git commit --message "$total_size"
  git push --force-with-lease
fi
