---
description: Show the agent status board — what every agent is doing right now.
---

Show the one-screen status board pulled from every agent's journal.

Run (it resolves your primary checkout automatically, so it's safe from a subdirectory
or a linked worktree):

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-status"
```

Relay the board. Call out any agent flagged `⚠ STALE`, anything `blocked`, and how many
agents are idle. If agents are blocked, suggest running `/loop:standup` for the
blocker/approval detail.

(If the plugin's `bin/` is on your PATH, `loop-status` is the same command.)
