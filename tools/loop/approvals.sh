#!/usr/bin/env bash
set -euo pipefail

printf "✅ Approval queue

"

if [ ! -d agents-status/approvals ]; then
  echo "No approvals directory found."
  exit 0
fi

found=0
while IFS= read -r file; do
  [ "$(basename "$file")" = "000-template.md" ] && continue
  if grep -q "Status: PENDING" "$file"; then
    found=1
    printf "--- %s ---
" "$file"
    grep -E "^# |^Status:|^Requested by:|^Suggested by:|^Date:" "$file" || true
    echo ""
  fi
done < <(find agents-status/approvals -type f -name '*.md' | sort)

[ "$found" -eq 0 ] && echo "No pending approvals."
