#!/usr/bin/env bash
set -euo pipefail

# Safely install the Multi-Agent Loop Kit into an EXISTING repo.
#
# Why this exists: a blind `cp -R kit/* your-repo/` would overwrite files an
# existing repo already has (README.md, package.json, LICENSE, .gitignore,
# AGENTS.md, ...). This installer NEVER overwrites an existing file. It:
#   - copies the operational kit files that don't exist yet
#   - for any collision, writes a `<name>.loopkit` copy beside yours instead,
#     and lists it so you can merge by hand
#   - prints the package.json scripts to add rather than replacing your file
#
# Usage:
#   bash scripts/install-into-repo.sh /path/to/your-repo
#   # or from your repo:  bash /path/to/kit/scripts/install-into-repo.sh .

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
  echo "Usage: bash scripts/install-into-repo.sh /path/to/your-repo"
  exit 1
fi
if [ ! -d "$TARGET" ]; then
  echo "Target is not a directory: $TARGET"
  exit 1
fi

# Resolve the kit root (parent of this script's dir).
KIT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$(cd "$TARGET" && pwd)"

if [ "$KIT" = "$TARGET" ]; then
  echo "Target is the kit itself. Point this at your own repo."
  exit 1
fi

if ! git -C "$TARGET" rev-parse --git-dir >/dev/null 2>&1; then
  echo "⚠️  $TARGET is not a git repo. The kit relies on git worktrees."
  echo "    Run 'git init' there first, or continue and init later."
fi

# Operational files a real repo needs. (Kit meta-files like the kit's own
# README, CHANGELOG, LICENSE, PRESSURE_TEST, ALL_IN_ONE, examples/ are NOT
# installed — they are for browsing the kit on GitHub, not for your repo.)
FILES=(
  AGENTS.md
  OPERATING_GUIDE.md
  RUNBOOK.md
  PROTOCOL.md
  LOOP_RADAR.md
  LOOP_MEMORY.md
  BLOCKERS.md
  OPERATOR_ASKS.md
)
DIRS=(
  prompts
  agents-status
  .cursor/rules
  tools
  docs
)
# Single files inside otherwise-shared dirs.
EXTRA_FILES=(
  scripts/bootstrap.sh
  scripts/install-into-repo.sh
  .github/pull_request_template.md
  .github/CODEOWNERS.example
  .github/workflows/pr-validation.yml
)

copied=0
skipped=()

copy_safe() {
  # copy_safe <src-abs> <rel-path>
  local src="$1" rel="$2" dst="$TARGET/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ]; then
    # Never overwrite. Drop a .loopkit copy beside it for manual merge.
    cp "$src" "$dst.loopkit"
    skipped+=("$rel  (yours kept; kit version at $rel.loopkit)")
  else
    cp "$src" "$dst"
    copied=$((copied + 1))
  fi
}

for f in "${FILES[@]}"; do
  [ -f "$KIT/$f" ] && copy_safe "$KIT/$f" "$f"
done

for d in "${DIRS[@]}"; do
  [ -d "$KIT/$d" ] || continue
  while IFS= read -r src; do
    rel="${src#"$KIT"/}"
    copy_safe "$src" "$rel"
  done < <(find "$KIT/$d" -type f)
done

for f in "${EXTRA_FILES[@]}"; do
  [ -f "$KIT/$f" ] && copy_safe "$KIT/$f" "$f"
done

# package.json: merge scripts, never replace.
echo ""
if [ -f "$TARGET/package.json" ]; then
  echo "📦 You already have a package.json — NOT touching it."
  echo "   Add these scripts to it if you want the shortcuts:"
  echo ""
  sed -n '/"scripts"/,/}/p' "$KIT/package.json" | sed 's/^/     /'
  echo ""
  echo "   (All scripts are just 'bash tools/...' — you can also run them directly.)"
else
  cp "$KIT/package.json" "$TARGET/package.json"
  copied=$((copied + 1))
  echo "📦 No package.json found — copied the kit's starter package.json."
fi

echo ""
echo "✅ Installed $copied file(s) into $TARGET"
if [ "${#skipped[@]}" -gt 0 ]; then
  echo ""
  echo "⚠️  ${#skipped[@]} file(s) already existed and were NOT overwritten."
  echo "   A .loopkit copy was placed beside each for you to merge:"
  for s in "${skipped[@]}"; do
    echo "   - $s"
  done
fi
echo ""
echo "Next:"
echo "  1. cd $TARGET"
echo "  2. Merge any .loopkit files listed above (especially AGENTS.md)."
echo "  3. bash scripts/bootstrap.sh"
echo "  4. Point your AI agent at prompts/setup-interview.md. It will inspect"
echo "     this repo, interview you, and propose AGENTS.md, LOOP_RADAR.md,"
echo "     ownership rules, prompts, and journals — stopping for your approval."
echo "     (Prefer to do it by hand? See OPERATING_GUIDE.md.)"
