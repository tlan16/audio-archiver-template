#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../" || exit 1

find . -type f -name "*.m4a" | parallel --line-buffer ./scripts/convert.sh --ungroup {}
