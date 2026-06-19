---
description: List all agent git worktrees and their branch / dirty / HEAD status.
---

List the agent worktrees for this repo.

Run from the repo root:

```
bash "${CLAUDE_PLUGIN_ROOT}/tools/list-agents.sh"
```

Relay the table: worktree path, branch, whether it's dirty, and HEAD. This is the
git-worktree view; `/loop:status` is the journal view of what each agent is working on.

(Shorthand if the plugin's `bin/` is on your PATH: `loop-agents`.)
