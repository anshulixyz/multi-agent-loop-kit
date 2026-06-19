---
description: List changed files for an ownership check against AGENTS.md.
argument-hint: "[base-branch]"
---

Run the ownership check helper (use during PR review).

Run, optionally passing a base branch in `$ARGUMENTS`:

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-ownership" $ARGUMENTS
```

This lists the files changed vs the base branch. Compare them against the ownership rules in
`AGENTS.md` and `.cursor/rules/01-ownership.mdc`, and flag any file an agent touched that it
does not own. The helper is intentionally conservative — it lists; you do the judging.

(If the plugin's `bin/` is on your PATH, `loop-ownership [base-branch]` is the same command.)
