---
name: make-this
description: >-
  Set up a supervised multi-agent coding loop in the current repository — spawn
  several AI coding agents that work in parallel git worktrees with file ownership,
  a shared radar, and human approval gates.
when_to_use: >-
  Use when the user wants to run multiple coding agents in parallel on this repo,
  set up parallel/multi-agent development, divide a codebase across several agents
  with ownership boundaries, or "turn this repo into a multi-agent loop". Also when
  they ask how to coordinate or supervise more than one AI coding agent here.
---

# Set up a multi-agent loop in this repo

The Multi-Agent Loop Kit turns a single repo into a supervised loop where several AI
coding agents work in parallel — each in its own git worktree and branch, each owning a
slice of the codebase, all visible on a shared radar, with a human approving the risky
moves.

To set it up, do exactly what the `/loop:make-this` command does:

1. Install the scaffolding into the current repo (never overwrites; writes `.loopkit`
   copies on collision):

   ```
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-into-repo.sh" .
   ```

   Report any `.loopkit` files that need a manual merge, especially `AGENTS.md`.

2. Run the setup interview — read `${CLAUDE_PLUGIN_ROOT}/prompts/setup-interview.md` and
   follow it: inspect the repo, interview the user about which agents to create, how to
   split ownership, and the goals, then propose `AGENTS.md`, `LOOP_RADAR.md`, ownership
   rules, per-agent prompts, and journals — pausing for approval before writing.

Once set up, the operator runs the loop with the other commands: `/loop:spawn` to create an
agent, `/loop:status` and `/loop:tick` to see what everyone's doing, `/loop:standup` and
`/loop:approvals` for the decision queue.

If the repo is not a git repository, flag that the kit relies on git worktrees and offer to
`git init` first.
