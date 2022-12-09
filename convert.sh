#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$PROJECT_DIR"
INPUT_FILE="$1"
TEMP_FILE="/tmp/$(uuidgen).m4a"
DOCKER_IMAGE="jrottenberg/ffmpeg:5.1.2-alpine313"

docker run -v "$PROJECT_DIR":"$PROJECT_DIR" -w "$PROJECT_DIR" "$DOCKER_IMAGE" \
  -stats \
  -i "$INPUT_FILE" \
  -c:v libfdk_aac  \
  -ac 2 \
  -profile:a aac_he_v2 \
  -b:a 20k \
  -c:v copy \
  "$TEMP_FILE"

mv "$TEMP_FILE" "$INPUT_FILE"
