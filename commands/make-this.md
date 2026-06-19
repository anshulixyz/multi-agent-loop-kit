---
description: Install the Multi-Agent Loop Kit into the current repo and run the setup interview.
argument-hint: "[target-dir]"
---

Turn the current repository into a supervised multi-agent loop.

1. Run the installer. With no argument it installs into your repo's primary checkout (safe
   to run from a subdirectory); pass a path in `$ARGUMENTS` to target a different repo:

   ```
   bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-make-this" $ARGUMENTS
   ```

   It never overwrites existing files — on any collision it writes a `<name>.loopkit`
   copy beside yours and lists it. Read that output and tell the user which files (if
   any) need a manual merge, **especially `AGENTS.md`**.

2. Then run the setup interview. Read `${CLAUDE_PLUGIN_ROOT}/prompts/setup-interview.md`
   and follow it: inspect this repo, interview the user about agents/ownership/goals, and
   propose `AGENTS.md`, `LOOP_RADAR.md`, ownership rules, per-agent prompts, and journals —
   stopping for the user's approval before writing anything substantive.

Do not skip the interview — installation only copies the scaffolding; the interview is what
adapts it to this repo. If the repo is not a git repository, point out that the kit relies on
git worktrees and offer to run `git init`.
