#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
cd "$PROJECT_DIR"

INPUT_FILE="$1"
TEMP_FILE="$(uuidgen).ogg"
TARGET_FILE="${INPUT_FILE%.*}.ogg"

echo "Converting $INPUT_FILE to $TARGET_FILE"

ffmpeg \
  -hide_banner \
  -loglevel error \
  -i "$INPUT_FILE" \
  -c:a libopus \
  -b:a 6k \
  -frame_duration:a 60 \
  -application:a voip \
  -cutoff:a 4000 \
  "$TEMP_FILE"

mv "$TEMP_FILE" "$TARGET_FILE"
rm "$INPUT_FILE"
