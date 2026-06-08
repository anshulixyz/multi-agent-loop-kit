#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-}"
SLUG="${2:-day-1}"

# Default base branch: don't assume "main". Many repos default to "master"
# (older git, existing/corporate repos). Derive it from the repo so the
# README quickstart works everywhere; fall back to main only as a last resort.
detect_base_branch() {
  # 1. origin's default branch, if a remote exists
  local ref
  ref="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [ -n "$ref" ]; then
    echo "${ref#origin/}"
    return
  fi
  # 2. the branch currently checked out
  ref="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  if [ -n "$ref" ]; then
    echo "$ref"
    return
  fi
  # 3. detached HEAD or unborn branch
  echo "main"
}

BASE_BRANCH="${3:-$(detect_base_branch)}"

if [ -z "$AGENT" ]; then
  cat <<'EOF'
Usage:
  bash tools/spawn-agent.sh <agent> [slug] [base-branch]

Base branch is optional. It defaults to your repo's default branch
(origin/HEAD, else the current branch), so you do not need to pass it
on main- or master-default repos.

Examples:
  bash tools/spawn-agent.sh frontend day-1
  bash tools/spawn-agent.sh anvil demo-replay
  bash tools/spawn-agent.sh backend day-1 develop   # override base branch

Creates a sibling git worktree:
  ../<repo>-<agent>

And branch:
  <agent>/<slug>
EOF
  exit 1
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not inside a git repository. Copy this kit into a git repo first."
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
REPO_NAME="$(basename "$REPO_ROOT")"
PARENT="$(dirname "$REPO_ROOT")"
WORKTREE_PATH="$PARENT/$REPO_NAME-$AGENT"
BRANCH="$AGENT/$SLUG"

if [ -e "$WORKTREE_PATH" ]; then
  echo "Worktree path already exists: $WORKTREE_PATH"
  echo "Use: git worktree list"
  exit 1
fi

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Branch already exists: $BRANCH"
  echo "Creating worktree from existing branch."
  git worktree add "$WORKTREE_PATH" "$BRANCH"
else
  echo "Creating branch $BRANCH from $BASE_BRANCH"
  git fetch origin "$BASE_BRANCH" >/dev/null 2>&1 || true
  if git show-ref --verify --quiet "refs/remotes/origin/$BASE_BRANCH"; then
    git worktree add -b "$BRANCH" "$WORKTREE_PATH" "origin/$BASE_BRANCH"
  elif git show-ref --verify --quiet "refs/heads/$BASE_BRANCH"; then
    git worktree add -b "$BRANCH" "$WORKTREE_PATH" "$BASE_BRANCH"
  else
    echo "Base branch '$BASE_BRANCH' not found locally or on origin." >&2
    echo "Pass an explicit base branch as the 3rd argument, e.g.:" >&2
    echo "  bash tools/spawn-agent.sh $AGENT $SLUG <your-default-branch>" >&2
    exit 1
  fi
fi

mkdir -p "$WORKTREE_PATH/agents-status"
if [ -f "$WORKTREE_PATH/agents-status/JOURNAL_TEMPLATE.md" ] && [ ! -f "$WORKTREE_PATH/agents-status/$AGENT.md" ]; then
  sed "s/<Codename>/$AGENT/g; s/<codename>/$AGENT/g" "$WORKTREE_PATH/agents-status/JOURNAL_TEMPLATE.md" > "$WORKTREE_PATH/agents-status/$AGENT.md"
  echo "Created journal: agents-status/$AGENT.md"
fi

echo ""
echo "✅ Spawned $AGENT"
echo "Worktree: $WORKTREE_PATH"
echo "Branch:   $BRANCH"
echo ""
echo "Next: open this path in Cursor / Claude Code / Codex and paste prompts/$AGENT.md or prompts/coding-agent.md."
