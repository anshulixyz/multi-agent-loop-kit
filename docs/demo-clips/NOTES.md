# Demo clips — source material for editing

These are the raw clips behind the README demo. Edit / reorder / rescore freely.

## Scene clips (numbered = suggested order)
| File | What it shows |
|---|---|
| `01-intro-chat.mp4` | chat-style "set up the loop" intro |
| `02-worktrees.mp4` | one repo → per-agent git worktrees (concept diagram) |
| `03-agents-grid.mp4` | 2×2 of Claude Code windows working in parallel |
| `04-operator-cli.mp4` | the operator's `/loop:status` → approve flow |

All are **1280×720** after stitching; the standalone scene MP4s are at their native
sizes (820–1120 px wide). GIF versions (`*.gif`) are what the README embeds.

## The reel
`loop-reel.mp4` — the four scenes stitched with title cards, a gentle zoom, and an
audio bed. ~71s, 1280×720, H.264 + AAC.

## Audio
`audio-bed.wav` — a **synthesized placeholder** (soft C-major pad, not licensed
music). Mean ≈ −14 dB, peak ≈ −3 dB. Swap in any track you like.

## Re-stitch after editing
```bash
# reorder/replace the scene clips, then concat (all must be same WxH/fps):
ffmpeg -i 01-intro-chat.mp4 -i 02-worktrees.mp4 -i 03-agents-grid.mp4 -i 04-operator-cli.mp4 \
  -filter_complex "[0:v][1:v][2:v][3:v]concat=n=4:v=1:a=0[v]" -map "[v]" out.mp4
# add audio:
ffmpeg -i out.mp4 -i audio-bed.wav -map 0:v -map 1:a -c:v copy -c:a aac -shortest reel.mp4
```

## Source HTML (in `src/`)
Each scene is a standalone auto-playing HTML file — tweak text/pacing/colors there
and re-screen-record, or open in a browser and capture. `title-open/close` are the
reel's end cards.
