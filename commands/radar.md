---
description: Summarize the loop radar and open task briefs.
---

Summarize the loop radar.

Run (resolves your primary checkout automatically):

```
bash "${CLAUDE_PLUGIN_ROOT}/bin/loop-radar"
```

This prints `LOOP_RADAR.md` plus the list of open task briefs. Relay it. Note that the radar
is maintained by Beacon via `prompts/beacon.md` — this command only summarizes the files, it
does not update them.

(If the plugin's `bin/` is on your PATH, `loop-radar` is the same command.)
