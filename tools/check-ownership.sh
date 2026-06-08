#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
🔐 Ownership check helper

This is intentionally conservative. It does not parse AGENTS.md automatically yet.
Use it in PR review to list changed files and compare them against AGENTS.md / .cursor/rules/01-ownership.mdc.
EOF

echo ""
if git rev-parse --git-dir >/dev/null 2>&1; then
  if [ -n "${1:-}" ]; then
    base="$1"
  else
    base=""
    # 1. origin's default branch
    ref="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@' || true)"
    if [ -n "$ref" ] && git show-ref --verify --quiet "refs/remotes/origin/$ref"; then
      base="origin/$ref"
    fi
    # 2. a common local default branch — NOT the current branch (in a worktree
    #    the current branch is the agent's feature branch; diffing it against
    #    itself shows nothing).
    if [ -z "$base" ]; then
      for b in main master develop; do
        if git show-ref --verify --quiet "refs/heads/$b"; then base="$b"; break; fi
      done
    fi
    # 3. last resort: the parent commit, with a warning.
    if [ -z "$base" ] && git rev-parse --quiet --verify HEAD~1 >/dev/null 2>&1; then
      base="HEAD~1"
      echo "(no default branch found — comparing against HEAD~1; pass a base explicitly for accuracy)"
    fi
  fi

  if [ -z "$base" ]; then
    echo "Could not determine a base branch."
    echo "Pass one explicitly:  bash tools/check-ownership.sh <base-branch>"
  else
    echo "Changed files against $base:"
    git diff --name-only "$base"...HEAD 2>/dev/null || git diff --name-only
  fi
else
  echo "Not a git repo."
fi

echo ""
echo "Manual gate: every changed file must be inside the agent's owned paths or have an approval/proposal link."
