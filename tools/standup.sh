#!/usr/bin/env bash
set -euo pipefail

printf "🧾 Multi-agent standup

"

now="$(date '+%Y-%m-%d %H:%M:%S')"
printf "Generated: %s

" "$now"

section() {
  printf "
## %s

" "$1"
}

journal_section_bullets() {
  local file="$1"
  local heading="$2"
  awk -v h="$heading" '
    $0 == "## " h {flag=1; next}
    /^## / {flag=0}
    flag {print}
  ' "$file" | grep -E '^- ' | grep -vE '^- nothing$' || true
}

section "Git"
if git rev-parse --git-dir >/dev/null 2>&1; then
  printf "Branch: %s
" "$(git branch --show-current 2>/dev/null || echo unknown)"
  printf "Dirty files: %s
" "$(git status --short 2>/dev/null | wc -l | tr -d ' ')"
  if command -v gh >/dev/null 2>&1; then
    printf "
Open PRs:
"
    gh pr list --limit 20 2>/dev/null || echo "GitHub CLI unavailable or not authenticated."
  fi
else
  echo "Not a git repo."
fi

section "Pending approvals"
if [ -d agents-status/approvals ]; then
  found=0
  while IFS= read -r file; do
    [ "$(basename "$file")" = "000-template.md" ] && continue
    if grep -q "Status: PENDING" "$file"; then
      found=1
      printf -- "- %s
" "$file"
    fi
  done < <(find agents-status/approvals -type f -name '*.md' | sort)
  [ "$found" -eq 0 ] && echo "- nothing"
else
  echo "- approvals directory missing"
fi

section "Open proposals"
if [ -d agents-status/proposals ]; then
  found=0
  while IFS= read -r file; do
    [ "$(basename "$file")" = "000-template.md" ] && continue
    if grep -Eq "Status: (OPEN|PENDING)" "$file"; then
      found=1
      printf -- "- %s
" "$file"
    fi
  done < <(find agents-status/proposals -type f -name '*.md' | sort)
  [ "$found" -eq 0 ] && echo "- nothing"
else
  echo "- proposals directory missing"
fi

section "Blocked / waiting on"
if [ -d agents-status ]; then
  found=0
  while IFS= read -r file; do
    case "$file" in
      */JOURNAL_TEMPLATE.md|*/approvals/*|*/proposals/*|*/task-briefs/*) continue ;;
    esac
    block="$(journal_section_bullets "$file" "Blocked / waiting on")"
    if [ -n "$block" ]; then
      found=1
      printf "### %s
%s

" "$(basename "$file")" "$block"
    fi
  done < <(find agents-status -maxdepth 1 -type f -name '*.md' | sort)
  [ "$found" -eq 0 ] && echo "- nothing"
else
  echo "- agents-status directory missing"
fi

section "Discussion / operator asks"
if [ -d agents-status ]; then
  found=0
  while IFS= read -r file; do
    case "$file" in
      */JOURNAL_TEMPLATE.md|*/approvals/*|*/proposals/*|*/task-briefs/*) continue ;;
    esac
    asks="$(journal_section_bullets "$file" "Discussion needed" | grep -vE '\[task\]' || true)"
    if [ -n "$asks" ]; then
      found=1
      printf "### %s
%s

" "$(basename "$file")" "$asks"
    fi
  done < <(find agents-status -maxdepth 1 -type f -name '*.md' | sort)
  [ "$found" -eq 0 ] && echo "- nothing"
fi

# Write simple derived files for operator visibility.
{
  echo "# BLOCKERS"
  echo ""
  echo "Generated: $now"
  echo ""
  if [ -d agents-status ]; then
    while IFS= read -r file; do
      case "$file" in
        */JOURNAL_TEMPLATE.md|*/approvals/*|*/proposals/*|*/task-briefs/*) continue ;;
      esac
      block="$(journal_section_bullets "$file" "Blocked / waiting on")"
      [ -n "$block" ] && printf "## %s

%s

" "$(basename "$file")" "$block"
    done < <(find agents-status -maxdepth 1 -type f -name '*.md' | sort)
  fi
} > BLOCKERS.md

{
  echo "# OPERATOR_ASKS"
  echo ""
  echo "Generated: $now"
  echo ""
  if [ -d agents-status ]; then
    while IFS= read -r file; do
      case "$file" in
        */JOURNAL_TEMPLATE.md|*/approvals/*|*/proposals/*|*/task-briefs/*) continue ;;
      esac
      asks="$(journal_section_bullets "$file" "Discussion needed" | grep -vE '\[task\]' || true)"
      [ -n "$asks" ] && printf "## %s

%s

" "$(basename "$file")" "$asks"
    done < <(find agents-status -maxdepth 1 -type f -name '*.md' | sort)
  fi
} > OPERATOR_ASKS.md

printf "
Updated BLOCKERS.md and OPERATOR_ASKS.md
"
