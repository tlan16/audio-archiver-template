#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$PROJECT_DIR"

URL="https://www.youtube.com/watch?v=gTG1ah53LBE"

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
  --exec "./convert.sh {}" \
  "$URL"

rm -f ./*.xml
