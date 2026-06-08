#!/usr/bin/env bash
set -euo pipefail

printf "🛰️  Beacon loop scan helper

"
printf "This helper prints repo signals for a Beacon AI session.
"
printf "It does not run an autonomous daemon or update LOOP_RADAR.md by itself.

"

printf "Suggested Beacon prompt:
"
printf "Read prompts/beacon.md and use the scan below as context. Update LOOP_RADAR.md, task briefs, and agents-status/beacon.md.

"

printf "## Files to inspect
"
printf -- "- LOOP_RADAR.md
- LOOP_MEMORY.md
- agents-status/*.md
- agents-status/proposals/*.md
- agents-status/approvals/*.md
- agents-status/task-briefs/*.md

"

if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  printf "## Git branch
"
  git branch --show-current || true
  printf "
## Git status
"
  git status --short || true
  printf "
## Recent commits
"
  git --no-pager log --oneline -10 || true
fi

if command -v gh >/dev/null 2>&1; then
  printf "
## Open PRs
"
  gh pr list --limit 20 || true
fi
