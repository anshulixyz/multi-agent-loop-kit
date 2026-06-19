---
description: Summarize the loop radar and open task briefs.
---

Summarize the loop radar.

Run from the repo root:

```
bash "${CLAUDE_PLUGIN_ROOT}/tools/loop/radar.sh"
```

This prints `LOOP_RADAR.md` plus the list of open task briefs. Relay it. Note that the radar
is maintained by Beacon via `prompts/beacon.md` — this command only summarizes the files, it
does not update them.

(Shorthand if the plugin's `bin/` is on your PATH: `loop-radar`.)
