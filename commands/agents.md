---
description: List all agent git worktrees and their branch / dirty / HEAD status.
---

List the agent worktrees for this repo.

Run (resolves your primary checkout automatically):

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-agents"
```

Relay the table: worktree path, branch, whether it's dirty, and HEAD. This is the
git-worktree view; `/loop:status` is the journal view of what each agent is working on.

(If the plugin's `bin/` is on your PATH, `loop-agents` is the same command.)
