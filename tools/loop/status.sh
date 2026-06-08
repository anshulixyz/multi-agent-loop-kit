#!/usr/bin/env bash
set -euo pipefail

# One-screen status board: what every agent is doing right now, pulled from
# their journals. This is the "show me everyone at a glance" view.
# (standup.sh answers "what needs ME"; this answers "what is everyone doing".)

printf "📋 Agent status board\n\n"
now_epoch="$(date +%s)"
STALE_HOURS="${LOOP_STALE_HOURS:-24}"

if [ ! -d agents-status ]; then
  echo "No agents-status/ directory. Run from your repo root after setup."
  exit 0
fi

# Pull the bullets under a given "## Heading" from a journal, dropping "nothing".
section() {
  awk -v h="$1" '
    $0 == "## " h {flag=1; next}
    /^## / {flag=0}
    flag {print}
  ' "$2" | grep -E '^- ' | grep -vE '^- nothing$' || true
}

agent_count=0
idle=0
blocked_total=0

while IFS= read -r f; do
  base="$(basename "$f")"
  case "$base" in
    JOURNAL_TEMPLATE.md) continue ;;
  esac
  codename="${base%.md}"
  agent_count=$((agent_count + 1))

  # Last-updated + staleness.
  updated="$(grep -m1 -E '^Last updated:' "$f" | sed 's/^Last updated:[[:space:]]*//' || true)"
  branch="$(grep -m1 -E '^Branch:' "$f" | sed 's/^Branch:[[:space:]]*//' | tr -d '`' || true)"
  stale_flag=""
  if [ -n "$updated" ]; then
    # GNU date (Linux/WSL) uses -d; BSD date (macOS) uses -j -f. Try both.
    upd_epoch="$(date -d "$updated" +%s 2>/dev/null \
      || date -j -f '%Y-%m-%d %H:%M' "$updated" +%s 2>/dev/null \
      || echo 0)"
    if [ "$upd_epoch" -gt 0 ]; then
      age_h=$(( (now_epoch - upd_epoch) / 3600 ))
      [ "$age_h" -ge "$STALE_HOURS" ] && stale_flag="  ⚠ STALE (${age_h}h)"
    fi
  fi

  now="$(section "Now" "$f")"
  blocked="$(section "Blocked / waiting on" "$f")"
  next="$(section "Next" "$f")"
  shipped="$(section "Just shipped" "$f")"

  [ -n "$blocked" ] && blocked_total=$((blocked_total + 1))
  [ -z "$now" ] && idle=$((idle + 1))

  printf "● %s" "$codename"
  [ -n "$branch" ] && printf "  [%s]" "$branch"
  [ -n "$updated" ] && printf "  · updated %s" "$updated"
  printf "%s\n" "$stale_flag"

  if [ -n "$now" ]; then
    printf "    now:     %s\n" "$(echo "$now" | sed 's/^- //' | paste -sd '; ' -)"
  else
    printf "    now:     (idle — nothing in progress)\n"
  fi
  [ -n "$blocked" ] && printf "    blocked: %s\n" "$(echo "$blocked" | sed 's/^- //' | paste -sd '; ' -)"
  [ -n "$next" ]    && printf "    next:    %s\n" "$(echo "$next"    | sed 's/^- //' | paste -sd '; ' -)"
  [ -n "$shipped" ] && printf "    shipped: %s\n" "$(echo "$shipped" | sed 's/^- //' | paste -sd '; ' -)"
  printf "\n"
done < <(find agents-status -maxdepth 1 -type f -name '*.md' | sort)

printf -- "----------------------------------------\n"
printf "%s agent(s) · %s idle · %s blocked\n" "$agent_count" "$idle" "$blocked_total"
if [ "$blocked_total" -gt 0 ]; then
  printf "Run 'bash tools/standup.sh' for the blocker/approval detail.\n"
fi
exit 0
