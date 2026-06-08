# Approval Request: Cockpit demo replay

Status: APPROVED
Requested by: Watchtower
Suggested by: Beacon
Date: 2026-06-08

---

## Summary

Add a mock-only "Replay demo" mode to Cockpit that plays the canonical signal
fixture through the event view for the investor demo.

---

## Why this matters now

The demo objective needs the full Pad → Bus → agents → Cockpit story to be
shown reliably. Without replay, a single mid-demo misfire leaves no clean way to
re-run the flow. This directly de-risks the P0 "Demo coherence" factor.

---

## Related build factor

`LOOP_RADAR.md` → P0 #1 Demo coherence.
Task brief: `agents-status/task-briefs/001-cockpit-demo-replay.md`.

---

## Owned paths touched

- `apps/cockpit/**`

---

## Files likely touched

- `apps/cockpit/src/components/ReplayControl.tsx` (new)
- `apps/cockpit/src/lib/replay.ts` (new)
- `apps/cockpit/src/views/Dashboard.tsx` (wire in the control)

---

## Scope

The agent is allowed to:

- read the canonical fixture from `packages/iaip-mocks/**`
- add replay UI and replay logic inside `apps/cockpit/**`

The agent is not allowed to:

- touch `packages/iaip-types/**` (contracts)
- modify the fixture in `packages/iaip-mocks/**`
- touch other agents' paths
- add dependencies
- change product direction beyond this approval

---

## Risk level

low

Risk explanation:

> Dashboard-only, mock-only, inside a single owned path. No contract, Bus, or
> live-integration changes. Worst case is a visual bug isolated to Cockpit.

---

## Test gate

Commands the agent must run before PR:

```bash
bun typecheck
bun test --filter cockpit
```

---

## Expected output

- A working "Replay demo" control in Cockpit.
- Repeatable replay of all four state transitions from the existing fixture.

---

## Operator decision

- [x] Approved
- [ ] Rejected
- [ ] Needs changes

Decision notes:

> Project Lead, 2026-06-08 10:05 — Approved as scoped. Mock-only and inside
> `apps/cockpit/**`, so low risk. One constraint: replay must read the fixture
> from `packages/iaip-mocks/**` at runtime, not vendor a copy into Cockpit, so
> the demo stays in sync when Conduit updates the fixture. Ship behind the
> existing dashboard, no new top-level route.
