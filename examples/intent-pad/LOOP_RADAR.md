# Intent Pad Loop Radar Example

Last updated: 2026-06-08 12:25
Updated by: Beacon

> This radar shows the state **after** one worked loop iteration. See
> `WALKTHROUGH.md` for the full Beacon → Watchtower → Project Lead cycle that
> shipped the Cockpit demo replay below.

---

## Current build objective

Ship the smallest investor-demo-ready Intent Pad flow where Pad captures a user signal, Bus normalizes it, subscribed agents react, and Cockpit shows the live coordination story.

---

## P0 build factors

### 1. Demo coherence

Status: 🟢 on track (was 🟡)

Why it matters:
The demo must feel like one connected system, not five isolated apps.

Evidence:

- Anvil owns Pad.
- Conduit owns Bus and shared client.
- Forager and Reel demonstrate subscribing agents.
- Watchtower owns Cockpit.
- ✅ Cockpit demo replay shipped 2026-06-08 — the full Pad → Bus → agents →
  Cockpit story can now be replayed from the canonical fixture. (Task brief
  `001`, approval `001`.)

Remaining task briefs:

- Create one canonical demo signal fixture. ✅ done (Conduit, `grocery-restock.json`)
- Create one replayable end-to-end demo script. ✅ done (Watchtower, replay mode)
- Make Cockpit show every state transition in the flow. ✅ covered by replay

Likely owners:

- Watchtower (done for this slice)

Approval needed: yes (granted for replay)

---

### 2. Contract stability

Status: 🔴 high risk

Why it matters:
If `packages/iaip-types/**` changes casually, every agent can break.

Suggested task briefs:

- Audit all consumers of IAIP signal types.
- Add a compatibility checklist before any contract proposal.
- Keep mock fixtures aligned with frozen types.

Likely owners:

- Project Lead
- Conduit

Approval needed: yes

---

### 3. Mocks-first independence

Status: 🟡 important

Why it matters:
Agents must not block each other waiting for real integrations.

Suggested task briefs:

- Add mock extractor fallback.
- Add mock MCP outcomes for Forager/Reel.
- Add Cockpit mock replay mode.

Likely owners:

- Conduit
- Forager
- Reel
- Watchtower

Approval needed: yes for behavior, no for docs-only planning

---

## P1 build factors

### 4. Operator visibility

Status: 🟡 needs polish

Suggested task briefs:

- Improve `bun standup` output.
- Surface stale journals.
- Surface blocked approvals.
- Generate `BLOCKERS.md` and `OPERATOR_ASKS.md` from journals.

Likely owners:

- Watchtower
- Beacon

Approval needed: yes if code changes, no for docs-only task briefs

---

## Rules for Beacon

Beacon may create task briefs from this radar.
Beacon may create approval requests.
Beacon may not approve or implement.
