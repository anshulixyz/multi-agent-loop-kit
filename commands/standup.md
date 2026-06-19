---
description: Generate a multi-agent standup — blockers, approvals, and what needs the operator.
---

Generate the standup: what needs the operator's attention across all agents.

Run from the repo root:

```
bash "${CLAUDE_PLUGIN_ROOT}/tools/standup.sh"
```

Relay the standup. Lead with anything blocked or awaiting approval — that's the operator's
queue. `/loop:status` answers "what is everyone doing"; this answers "what needs me".

(Shorthand if the plugin's `bin/` is on your PATH: `loop-standup`.)
