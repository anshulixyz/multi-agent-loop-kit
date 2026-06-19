---
description: Run one full loop sweep — status board, scan, radar, and standup together.
---

Run a full loop sweep in one pass. From the repo root:

```
bash "${CLAUDE_PLUGIN_ROOT}/tools/loop/status.sh" \
  && bash "${CLAUDE_PLUGIN_ROOT}/tools/loop/scan.sh" \
  && bash "${CLAUDE_PLUGIN_ROOT}/tools/loop/radar.sh" \
  && bash "${CLAUDE_PLUGIN_ROOT}/tools/standup.sh"
```

This runs the status board, the Beacon scan, the radar summary, and the standup back to back.
Synthesize the four outputs into a single operator briefing: who's working on what, what's
stale or blocked, what's on the radar, and what needs the operator's decision right now.

(Shorthand if the plugin's `bin/` is on your PATH: `loop-tick`.)
