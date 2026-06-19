---
description: Show what a given agent should read before coding, plus briefs/approvals mentioning it.
argument-hint: "<codename>"
---

Show the pre-coding listening checklist for an agent.

Run, passing the codename in `$ARGUMENTS`:

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-listen" $ARGUMENTS
```

If `$ARGUMENTS` is empty, ask the user which agent codename. This lists the files the agent
should read before coding and any task briefs / pending approvals that mention it. Relay it,
and reinforce the rule: if the task is not approved, the agent must create or update an
approval request and stop before implementation.

(If the plugin's `bin/` is on your PATH, `loop-listen <codename>` is the same command.)
