#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
cd "$PROJECT_DIR" || exit

# Read the list of URLs from the file URLs.txt
while read -r URL; do
  if [[ -n "$URL" ]]; then
    if [[ "$URL" =~ ^#.* ]]; then
      continue
    fi

    echo "Start downloading $URL"
    yt-dlp \
      --ignore-errors \
      --sleep-interval 1 \
      --max-sleep-interval 5 \
      --add-metadata \
      --embed-thumbnail \
      --embed-subs \
      --download-archive archive.txt \
      --concurrent-fragments 2 \
      --audio-format m4a \
      --extract-audio \
      --format "worstaudio/worst" \
      --exec "./scripts/convert.sh {}" \
      "$@" \
      "$URL"  | grep --invert-match "has already been recorded in the archive"
  fi
done <URLs.txt

# Remove unprocessed temp files
rm -f ./*.xml ./*.meta ./*.json ./*.png ./*.webp *.temp.* *part* *ytdl || ture
