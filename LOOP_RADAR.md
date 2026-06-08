# LOOP_RADAR.md

Last updated: YYYY-MM-DD HH:mm
Updated by: Beacon

---

## Current build objective

Replace this with the repo’s current objective.

Example:

> Ship the smallest investor-demo-ready local flow where user intent enters one surface, gets normalized by the system, triggers at least one subscribed agent, and is visible in a dashboard or log.

---

## Operator constraints

- Keep product decisions approval-gated.
- Keep contracts frozen unless proposal is approved.
- Keep agents inside owned paths.
- Prefer mocks-first progress.
- Prefer demo coherence over overbuilding.
- Do not let agents implement vague tasks.

---

## Top build factors

### 1. Demo coherence

Status: 🟡 needs work

Why it matters:

The product should feel like one connected system, not disconnected features.

Evidence:

- Add evidence from journals, PRs, code, or standup.

Suggested next tasks:

- Create canonical demo scenario fixture.
- Create an end-to-end demo script.
- Make dashboard/cockpit able to replay the scenario.

Likely owners:

- `<agent>`
- `<agent>`

Approval needed: yes

---

### 2. Contract stability

Status: 🟢 / 🟡 / 🔴

Why it matters:

Shared types/schemas unblock or block every other agent.

Evidence:

- Add contract status.

Suggested next tasks:

- Audit consumers.
- Add compatibility checklist.
- Create proposal for required schema changes.

Likely owners:

- operator
- `<contract-owner>`

Approval needed: yes

---

### 3. Blocked agents

Status: 🟢 / 🟡 / 🔴

Why it matters:

Blocked agents waste context windows and token budgets.

Evidence:

- Add blocked journal links.

Suggested next tasks:

- Unblock by owner.
- Create task brief.
- Ask operator for decision.

Likely owners:

- Beacon
- operator

Approval needed: depends

---

## Open task briefs

| Task brief | Priority | Suggested owner | Status |
|---|---|---|---|
| `agents-status/task-briefs/001-example.md` | P1 | frontend | OPEN |

---

## Open approval requests

| Approval | Requested by | Status | Operator action |
|---|---|---|---|
| `agents-status/approvals/001-example.md` | frontend | PENDING | approve/reject/edit |

---

## Beacon notes

- Keep this file short and ranked.
- Move stale detail to `LOOP_MEMORY.md`.
- Do not create more than 3 new P0/P1 task briefs in one loop.
