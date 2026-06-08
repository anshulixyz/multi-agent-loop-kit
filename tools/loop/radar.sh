#!/usr/bin/env bash
set -euo pipefail

printf "📡 Loop radar summary

"

if [ -f LOOP_RADAR.md ]; then
  sed -n '1,220p' LOOP_RADAR.md
else
  echo "LOOP_RADAR.md missing"
fi

printf "
## Task briefs

"
if [ -d agents-status/task-briefs ]; then
  find agents-status/task-briefs -type f -name '*.md' ! -name '000-template.md' | sort | sed 's#^#- #' || true
else
  echo "- task brief directory missing"
fi

printf "
Reminder: Beacon updates radar through prompts/beacon.md. This script only summarizes files.
"
