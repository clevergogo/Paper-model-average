#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
url_file="$root_dir/paper-pdf-urls.txt"
out_dir="$root_dir/papers"

mkdir -p "$out_dir"

while IFS= read -r url; do
  [ -n "$url" ] || continue

  name="$(basename "$url")"
  case "$url" in
    https://arxiv.org/pdf/*)
      name="${name%.pdf}.pdf"
      ;;
  esac

  name="$(printf '%s' "$name" | tr '/:' '__')"
  output="$out_dir/$name"

  if [ -s "$output" ]; then
    echo "skip $name"
    continue
  fi

  echo "download $url"
  curl -L --fail --retry 3 --connect-timeout 20 --max-time 300 -o "$output" "$url"
done < "$url_file"
