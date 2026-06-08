# Proposal: Add optional `schemaVersion` to IAIP signal contract

Status: DECIDED
Created by: Conduit
Date: 2026-06-08

---

## Context

While wiring Cockpit replay and the Forager/Reel mocks, Conduit noticed there is
no way to tell which version of an IAIP signal a consumer received. Today every
surface assumes the current shape of `packages/iaip-types/**`. If the contract
ever changes, older mocks, replays, and agents could silently misread signals.

This is **not** a task brief. It changes a frozen contract that every agent
depends on, so it needs a Project Lead decision before any code — exactly the
case where the loop uses a **proposal** instead of a task brief.

---

## Decision needed

Should we add an optional `schemaVersion` field to the IAIP signal type now, so
consumers can branch on it later?

---

## Options

### Option A — Do nothing

Pros:

- No contract change during demo crunch.
- No risk to the frozen `packages/iaip-types/**` package right now.

Cons:

- No forward compatibility signal if the contract changes after the demo.

### Option B — Add optional `schemaVersion?: string` now

Pros:

- Cheap to add; optional, so existing consumers keep working.
- Gives a hook for future migrations.

Cons:

- Touches the frozen contract package, so every consumer must be re-typechecked.
- Pulls focus from the P0 demo work for a benefit we don't need until later.
- Optional-but-unused fields tend to rot until something actually reads them.

### Option C — Defer until the contract audit (P0 #2)

Pros:

- Keeps the frozen contract stable through the demo.
- Folds the decision into the planned consumer audit, where we'll see every
  reader of the type at once and can version deliberately.

Cons:

- The forward-compat hook doesn't exist until then.

---

## Recommendation

Recommended option: **C — defer until the contract audit.**

Reason: the demo does not need versioning, and the safest time to touch a frozen
contract is when we are already auditing every consumer (radar P0 #2), not in the
middle of P0 demo work.

---

## Impact

Owned paths affected:

- `packages/iaip-types/**` (Project Lead owned, frozen)

Other agents affected:

- Anvil, Conduit, Forager, Reel, Watchtower (all consume the signal type)

Contracts affected:

- yes

Risk level:

- medium (low change, but broad blast radius across every consumer)

---

## Test / validation plan

```bash
bun typecheck
bun test
```

---

## Operator decision

Status: DECIDED

Decision:

> Project Lead, 2026-06-08 11:10 — Go with Option C. Do not change
> `packages/iaip-types/**` before the demo. Add `schemaVersion` as the first
> item in the contract audit (radar P0 #2) so we version with full visibility of
> every consumer.

Reason:

> Frozen contracts are the highest-blast-radius change in the repo. There is no
> demo need for versioning, so the cost is not justified yet.

Follow-up:

- Beacon: add a line to `LOOP_MEMORY.md` recording this deferral.
- Beacon: when the contract audit starts, open a task brief referencing this
  proposal so the decision is not lost.
