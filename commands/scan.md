---
description: Print repo signals (git, PRs, journals) as context for a Beacon session.
---

Gather repo signals for a Beacon loop session.

Run from the repo root:

```
bash "${CLAUDE_PLUGIN_ROOT}/tools/loop/scan.sh"
```

This prints branch, git status, recent commits, open PRs, and the files Beacon should
inspect. It does **not** run an autonomous daemon or update `LOOP_RADAR.md` by itself. If the
user wants the radar updated, read `${CLAUDE_PLUGIN_ROOT}/prompts/beacon.md` and act as Beacon
using this scan as context — updating `LOOP_RADAR.md`, task briefs, and `agents-status/beacon.md`.

(Shorthand if the plugin's `bin/` is on your PATH: `loop-scan`.)
