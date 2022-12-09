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
      --download-archive \
      archive.txt \
      --audio-format m4a \
      --extract-audio \
      --format "worstaudio/worst" \
      --exec "./scripts/convert.sh {}" \
      "$URL"
  fi
done <URLs.txt

rm -f ./*.xml
