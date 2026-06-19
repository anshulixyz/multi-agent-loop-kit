---
name: multi-agent-loop
description: >-
  Turn the current repository into a supervised multi-agent coding loop — spawn
  parallel AI coding agents in isolated git worktrees with file ownership, a shared
  radar, and human approval gates, then run the loop (status, standup, approvals)
  from one place.
when_to_use: >-
  Use when the user wants to run multiple coding agents in parallel on this repo,
  set up parallel / multi-agent development, divide a codebase across several agents
  with ownership boundaries, supervise more than one AI coding agent, or asks to
  "set up" or "run" a multi-agent loop here.
---

# Multi-Agent Loop Kit (skill)

This skill turns a repo into a supervised loop: several AI coding agents work in
parallel — each in its own git worktree and branch, each owning a slice of the
codebase, all visible on a shared radar — with a human approving the risky moves.
Nothing merges without the operator.

## How to run the tooling (important)

The loop scripts are **bundled in this skill's own directory**. Below, `SKILL_DIR`
means the folder that contains this `SKILL.md` (the directory this skill was loaded
from — e.g. `~/.claude/skills/multi-agent-loop`). Use that absolute path.

Two rules, every time:
1. **Invoke scripts by their absolute path under `SKILL_DIR`** (e.g.
   `bash "$SKILL_DIR/bin/loop-status"`).
2. **Run them while your working directory is the user's target repository**, not
   `SKILL_DIR`. Do **not** `cd` into the skill directory — the scripts auto-resolve
   the user repo's primary checkout from the current directory, so they must be run
   from inside the user's project (any subdirectory or worktree is fine).

If the user is not inside a git repository, point out that the kit relies on git
worktrees and offer to run `git init` first.

## 1 · Set it up (first time in a repo)

From the user's repo, install the kit scaffolding (never overwrites — collisions are
saved as `<name>.loopkit` for manual merge):

```
bash "$SKILL_DIR/scripts/install-into-repo.sh" .
```

Report any `.loopkit` files needing a manual merge, **especially `AGENTS.md`**. Then
run the setup interview: read `"$SKILL_DIR/prompts/setup-interview.md"` and follow it —
inspect the repo, interview the user about agents / ownership / goals, and propose
`AGENTS.md`, `LOOP_RADAR.md`, ownership rules, per-agent prompts, and journals,
pausing for approval before writing anything substantive. Don't skip the interview —
install only copies scaffolding; the interview adapts it to this repo.

## 2 · Run the loop

All of these auto-resolve the operator's primary checkout, so they're safe from a
subdirectory or a linked worktree:

| Goal | Command |
|---|---|
| Spawn an agent in its own worktree+branch | `bash "$SKILL_DIR/bin/loop-spawn" <codename> [slug]` |
| Status board — what every agent is doing | `bash "$SKILL_DIR/bin/loop-status"` |
| Standup — blockers / what needs the operator | `bash "$SKILL_DIR/bin/loop-standup"` |
| Pending approval queue | `bash "$SKILL_DIR/bin/loop-approvals"` |
| Radar + open task briefs | `bash "$SKILL_DIR/bin/loop-radar"` |
| Repo signals for a Beacon session | `bash "$SKILL_DIR/bin/loop-scan"` |
| One agent's pre-coding checklist | `bash "$SKILL_DIR/bin/loop-listen" <codename>` |
| Git state of every worktree | `bash "$SKILL_DIR/bin/loop-agents"` |
| Ownership check (PR review) | `bash "$SKILL_DIR/bin/loop-ownership" [base-branch]` |
| Full sweep (status→scan→radar→standup) | `bash "$SKILL_DIR/bin/loop-tick"` |

After spawning, tell the user to open the new worktree path in their agent of choice
and paste `prompts/<codename>.md` (or `prompts/coding-agent.md`) — each agent is its
own AI window.

## 3 · Stay in the loop (the rules that keep it safe)

- **You never auto-approve.** When an agent is blocked on an approval, surface it and
  let the user decide; approving means editing the request's `Status: PENDING` to
  approved. Only do that on the user's explicit go-ahead.
- **Nothing self-merges.** Agents build on their branch and open PRs; the human merges.
- The status board is only as honest as the journals — flag any agent marked `STALE`.

For the full operating model see `"$SKILL_DIR/OPERATING_GUIDE.md"` and
`"$SKILL_DIR/PROTOCOL.md"`.
