---
description: Run one full loop sweep — status board, scan, radar, and standup together.
---

Run a full loop sweep in one pass:

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-tick"
```

It resolves your primary checkout automatically (so the standup's derived files land in the
right place), then runs the status board, the Beacon scan, the radar summary, and the standup
back to back. Synthesize the four outputs into a single operator briefing: who's working on
what, what's stale or blocked, what's on the radar, and what needs the operator's decision
right now.

(If the plugin's `bin/` is on your PATH, `loop-tick` is the same command.)
