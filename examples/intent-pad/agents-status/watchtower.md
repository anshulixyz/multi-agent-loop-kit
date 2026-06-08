# Watchtower Status

Last updated: 2026-06-08 12:20
Branch: `watchtower/demo-replay`
Worktree: `~/Documents/intent-pad-watchtower`

---

## Now

- nothing — demo replay shipped, waiting on Project Lead merge of the PR

---

## Just shipped

- Cockpit "Replay demo" mode (approval `001-watchtower-demo-replay.md`)
  - reads canonical fixture from `packages/iaip-mocks/**` at runtime
  - steps through all four state transitions with a readable delay
  - re-runnable without reload, no console errors
  - tests: `bun typecheck` + `bun test --filter cockpit` green
  - PR: `Watchtower: add cockpit demo replay` → into `main`

---

## Blocked / waiting on

- nothing

---

## Discussion needed

- nothing

Use formats:

```txt
[task] <agent>: <action needed>
[approval] operator: <approval file>
[setup] operator: <setup needed>
[launch] operator: <launch/demo action>
```

---

## Approvals open

- nothing — `001-watchtower-demo-replay.md` is APPROVED and shipped

---

## Proposals open

- nothing

---

## Next

- [launch] operator: dry-run the full demo with replay before investor call
- consider a "step forward / step back" control if the live demo needs pauses
  (would need a new approval; out of scope for the current one)

---

## Notes

- Confirmed replay reads the fixture from `packages/iaip-mocks/**` rather than
  vendoring a copy, per the Project Lead's approval constraint. If Conduit
  updates `grocery-restock.json`, replay picks it up automatically.
