---
description: Show the agent status board — what every agent is doing right now.
---

Show the one-screen status board pulled from every agent's journal.

Run from the repo root:

```
bash "${CLAUDE_PLUGIN_ROOT}/tools/loop/status.sh"
```

Relay the board. Call out any agent flagged `⚠ STALE`, anything `blocked`, and how many
agents are idle. If agents are blocked, suggest running `/loop:standup` for the
blocker/approval detail.

(Shorthand if the plugin's `bin/` is on your PATH: `loop-status`.)
