---
description: Generate a multi-agent standup — blockers, approvals, and what needs the operator.
---

Generate the standup: what needs the operator's attention across all agents.

Run (it resolves and writes into your primary checkout, so it won't litter derived files
into a subdirectory or worktree):

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-standup"
```

Relay the standup. Lead with anything blocked or awaiting approval — that's the operator's
queue. `/loop:status` answers "what is everyone doing"; this answers "what needs me".

(If the plugin's `bin/` is on your PATH, `loop-standup` is the same command.)
