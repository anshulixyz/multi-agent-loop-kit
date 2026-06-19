---
description: Spawn a coding agent in its own git worktree and branch.
argument-hint: "<codename> [slug] [base-branch]"
---

Spawn a new coding agent for this repo.

Run (passing the codename / slug / base-branch the user gave in `$ARGUMENTS`):

```
bash "${CLAUDE_PLUGIN_ROOT}/tools/spawn-agent.sh" $ARGUMENTS
```

This creates a sibling git worktree (`../<repo>-<codename>`) on branch `<codename>/<slug>`
and seeds the agent's journal at `agents-status/<codename>.md`. The base branch defaults to
the repo's default branch.

If `$ARGUMENTS` is empty, ask the user for at least a codename (e.g. `frontend`, `anvil`)
before running. After it succeeds, relay the worktree path and branch, and remind the user to
open that path in their agent of choice and paste `prompts/<codename>.md` (or
`prompts/coding-agent.md`).

(Shorthand if the plugin's `bin/` is on your PATH: `loop-spawn <codename> [slug]`.)
