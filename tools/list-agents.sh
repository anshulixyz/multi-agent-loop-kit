#!/usr/bin/env bash
set -euo pipefail

printf "🧭 Agent worktree status

"

if ! command -v git >/dev/null 2>&1; then
  echo "git is not installed or not on PATH."
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not inside a git repository."
  echo "This helper works after the kit is copied into a git repo."
  exit 0
fi

printf "%-28s %-32s %-12s %-8s
" "WORKTREE" "BRANCH" "DIRTY" "HEAD"
printf "%-28s %-32s %-12s %-8s
" "--------" "------" "-----" "----"

git worktree list --porcelain | awk '
  /^worktree / { wt=$2 }
  /^HEAD / { head=substr($2,1,8) }
  /^branch / { branch=$2; sub("refs/heads/", "", branch); print wt "	" branch "	" head }
' | while IFS=$'	' read -r wt branch head; do
  if [ -d "$wt" ]; then
    dirty=$(git -C "$wt" status --short 2>/dev/null | wc -l | tr -d ' ')
  else
    dirty="?"
  fi
  printf "%-28s %-32s %-12s %-8s
" "$(basename "$wt")" "$branch" "$dirty file(s)" "$head"
done

printf "
Tip: one coding agent should run in one worktree and one AI window.
"
