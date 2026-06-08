#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-}"

if [ -z "$AGENT" ]; then
  echo "Usage: bash tools/loop/listen.sh <agent>"
  exit 1
fi

printf "👂 Loop listen helper for: %s

" "$AGENT"
printf "Before coding, the agent should read:
"
printf -- "- AGENTS.md
- LOOP_RADAR.md
- agents-status/task-briefs/*.md
- agents-status/approvals/*.md
- agents-status/%s.md
- .cursor/rules/05-loop-listening.mdc

" "$AGENT"

printf "Relevant task briefs mentioning %s:
" "$AGENT"
if [ -d agents-status/task-briefs ]; then
  grep -Ril "$AGENT" agents-status/task-briefs/*.md 2>/dev/null | grep -v '000-template.md' || echo "No direct mentions found."
else
  echo "No task brief directory found."
fi

printf "
Pending approvals mentioning %s:
" "$AGENT"
if [ -d agents-status/approvals ]; then
  grep -Ril "$AGENT" agents-status/approvals/*.md 2>/dev/null | grep -v '000-template.md' || echo "No direct mentions found."
else
  echo "No approvals directory found."
fi

printf "
Agent rule: if the task is not approved, create or update an approval request and stop before implementation.
"
