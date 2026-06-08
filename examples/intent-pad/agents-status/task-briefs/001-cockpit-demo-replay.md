# Task Brief: Cockpit demo replay

Status: CLAIMED
Created by: Beacon
Recommended owner: Watchtower
Priority: P0
Approval required: yes
Date: 2026-06-08

---

## Build factor

Supports **P0 #1 — Demo coherence** in `LOOP_RADAR.md`.

The investor demo currently has no way to show the full Pad → Bus → agents →
Cockpit story end to end. Each surface works in isolation, but there is nothing
that plays the whole flow back as one connected sequence.

---

## Context

What Beacon observed during the loop scan on 2026-06-08:

- Conduit shipped `packages/iaip-mocks/**` with a canonical signal fixture
  (`grocery-restock.json`). See `conduit` journal, "Just shipped".
- Anvil can emit that fixture from Pad; Forager and Reel can react to it.
- Cockpit (`apps/cockpit/**`) renders live events but has **no replay mode**:
  if an agent misfires mid-demo, there is no clean way to re-run the story.
- This is the single biggest risk to a smooth investor demo, and it sits
  entirely inside one owned path, so it is a clean P0.

---

## Suggested task

Add a **replay mode** to Cockpit that plays the canonical demo fixture through
the existing event view at a controlled pace, using mock data only.

The agent should:

- read the existing fixture from `packages/iaip-mocks/**` (do not duplicate it)
- add a "Replay demo" control to the Cockpit dashboard
- step through each state transition (signal captured → normalized →
  agent reacted → result shown) with a readable delay between steps
- make replay idempotent and re-runnable without a page reload

---

## Ownership fit

`apps/cockpit/**` is owned solely by Watchtower. Replay is a dashboard concern,
not a Bus or contract concern, so no cross-boundary work is required as long as
Watchtower **consumes** the existing fixture rather than changing it.

---

## Non-goals

The agent should not:

- touch `packages/iaip-types/**` (frozen contracts, Project Lead owned)
- modify the fixture in `packages/iaip-mocks/**` (Conduit owns it)
- edit Pad, Bus, or any agent code
- add a new dependency without approval
- change product direction

---

## Acceptance criteria

- [ ] A "Replay demo" control exists in Cockpit.
- [ ] Replay plays the canonical fixture through all four state transitions.
- [ ] Replay reads the fixture from `packages/iaip-mocks/**`, not a copy.
- [ ] Replay can be run repeatedly without reload and without console errors.
- [ ] No files outside `apps/cockpit/**` are modified.

---

## Suggested test gate

```bash
bun typecheck
bun test --filter cockpit
```

---

## Agent response

**Watchtower (2026-06-08 09:40):** `I can take this.` Replay is dashboard-only
and fits inside `apps/cockpit/**`. I will consume the existing fixture and not
touch mocks or contracts. Creating an approval request before implementation.

---

## Linked approval

`agents-status/approvals/001-watchtower-demo-replay.md`
