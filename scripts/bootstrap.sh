#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
🧰 Multi-Agent Loop Kit bootstrap

This script does not overwrite your repo-specific decisions.
It checks required folders/files and creates missing starter journals.
EOF

dirs=(
  prompts
  agents-status
  agents-status/proposals
  agents-status/approvals
  agents-status/task-briefs
  .cursor/rules
  tools/loop
  .github
)

for dir in "${dirs[@]}"; do
  mkdir -p "$dir"
done

if [ -f agents-status/JOURNAL_TEMPLATE.md ]; then
  # Seed only Beacon's journal — Beacon is the one role present in every setup.
  # Real coding-agent journals are created by the setup interview (or
  # tools/spawn-agent.sh), so we do NOT fabricate generic frontend/backend/etc.
  if [ ! -f agents-status/beacon.md ]; then
    sed "s/<Codename>/beacon/g; s/<codename>/beacon/g" agents-status/JOURNAL_TEMPLATE.md > agents-status/beacon.md
    echo "Created agents-status/beacon.md"
  fi
fi

if [ ! -f LOOP_RADAR.md ]; then
  cat > LOOP_RADAR.md <<'RADAR'
# Loop Radar

Last updated: YYYY-MM-DD HH:mm
Updated by: Beacon

## Current build objective

Define the smallest valuable build objective for this repo.

## Top build factors

### 1. Demo/product coherence

Status: 🟡 needs scan
Why it matters: The product must feel like one connected system.
Evidence:
- Add evidence here.
Suggested next tasks:
- Add task here.
Likely owners:
- frontend
Approval needed: yes
RADAR
  echo "Created LOOP_RADAR.md"
fi

echo ""
echo "✅ Bootstrap check complete."
echo "Next: create your real agents. The easiest way is the setup interview —"
echo "point your AI agent at prompts/setup-interview.md and it will fill in"
echo "AGENTS.md, .cursor/rules/01-ownership.mdc, LOOP_RADAR.md, and one prompt +"
echo "journal per agent for YOUR repo. (Or do it by hand per OPERATING_GUIDE.md.)"
