#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$PROJECT_DIR"

#URL="https://space.bilibili.com/316568752"
URL="https://www.bilibili.com/video/BV1dR4y1Q7zV"

yt-dlp \
  --verbose \
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
  --exec "./convert.sh {}" \
  "$URL"

rm -f ./*.xml
