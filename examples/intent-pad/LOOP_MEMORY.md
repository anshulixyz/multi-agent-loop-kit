# Intent Pad Loop Memory

Durable decisions and lessons from past loop iterations. Beacon appends here;
only the Project Lead marks decisions final. This is the "Beacon learns" step.

---

## 2026-06-08 — Cockpit demo replay (loop iteration #1)

**Decision (Project Lead):** Cockpit replay must read the demo fixture from
`packages/iaip-mocks/**` at runtime, never vendor a copy into `apps/cockpit/**`.

**Why it stays true:** keeps the demo in sync when Conduit updates the fixture.
Any future Cockpit feature that needs demo data should consume the shared
fixture, not duplicate it.

**Outcome:** demo coherence (P0 #1) moved 🟡 → 🟢 for the Cockpit slice.

**Lesson for Beacon:** the cleanest P0 briefs are the ones that sit entirely
inside one owned path. Replay qualified because it was dashboard-only. Briefs
that span Pad + Bus + contracts should be split or sent to the Project Lead as a
proposal first, not briefed as a single task.

Trace:

- radar factor: P0 #1 Demo coherence
- task brief: `agents-status/task-briefs/001-cockpit-demo-replay.md`
- approval: `agents-status/approvals/001-watchtower-demo-replay.md`
- shipped by: Watchtower, branch `watchtower/demo-replay`

---

## 2026-06-08 — Defer `schemaVersion` on IAIP contract (proposal #1)

**Decision (Project Lead):** Do not add `schemaVersion` to
`packages/iaip-types/**` before the demo. Fold it into the contract audit
(radar P0 #2) so the type is versioned with full visibility of every consumer.

**Why it stays true:** frozen contracts have the widest blast radius in the
repo. Version them deliberately during the audit, never ad hoc.

**Lesson for Beacon:** this was raised as a **proposal, not a task brief**,
because it changes a frozen contract that every agent depends on. Cross-cutting
or contract-level changes need a Project Lead decision *before* any code. Beacon
should not turn these into task briefs.

Trace:

- proposal: `agents-status/proposals/001-contract-version-field.md`
- related radar factor: P0 #2 Contract stability (still 🔴)

---

## Frozen decisions

- `packages/iaip-types/**` is the single frozen contract package. Changes require
  a proposal and a Project Lead decision (P0 #2, still 🔴 — audit consumers
  before any change).
