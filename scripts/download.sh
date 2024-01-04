#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
cd "$PROJECT_DIR" || exit 1

# Github codespaces
if [[ "$(uname -a)" == *"codespace"* ]]; then
  sudo apt-get update
  sudo apt-get install -y aria2 uuid-runtime python3-mutagen python3-certifi ca-certificates python3-brotli python3-websockets python3-xattr python3-pycryptodome python3-m3u8 httpie ffmpeg parallel
  pip install --upgrade phantomjs dash httpie
  pipx install yt-dlp
fi

# Add $HOME/.python/current/bin to path if exists
if [ -d "$HOME/.bin" ] ; then
  export PATH="$PATH:$HOME/.bin"
fi
if [ -d "$HOME/.python/current/bin" ] ; then
  export PATH="$PATH:$HOME/.python/current/bin"
fi

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
      --extract-audio \
      --audio-quality 5 \
      --add-metadata \
      --embed-thumbnail \
      --embed-subs \
      --trim-filenames 80 \
      --downloader aria2c \
      --downloader "dash,m3u8:native" \
      --download-archive archive.txt \
      --concurrent-fragments 2 \
      --no-playlist \
      --match-filters '!is_live' \
      --format "worstaudio/worst" \
      --exec "./scripts/convert.sh {}" \
      "$@" \
      "$URL" \
     | grep --invert-match --ignore-case 'has already been recorded in the archive' \
     | grep --invert-match --ignore-case 'Error 401: Unauthorized' \
     | grep --invert-match --ignore-case 'fragment not found' \
     | grep --invert-match --ignore-case 'The download speed shown is only of one thread' \
     || true
  fi
done <URLs.txt

# Remove unprocessed temp files
rm -f ./*.xml ./*.meta ./*.json ./*.png ./*.webp *.temp.* *part* *ytdl || ture

echo "Done"
exit 0
