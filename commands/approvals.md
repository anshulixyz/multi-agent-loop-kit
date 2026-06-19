---
description: Show the pending approval queue.
---

Show pending approval requests from `agents-status/approvals/`.

Run (resolves your primary checkout automatically):

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-approvals"
```

Relay each pending request with its requester and date. For each, help the user decide:
approving means editing the request's `Status: PENDING` to approved and unblocking the agent.
Do not approve anything yourself without the user's explicit go-ahead.

(If the plugin's `bin/` is on your PATH, `loop-approvals` is the same command.)
