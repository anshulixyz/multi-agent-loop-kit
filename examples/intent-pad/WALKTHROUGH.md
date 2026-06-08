# Worked Loop Iteration: Cockpit demo replay

This is one **real, populated loop iteration** for the Intent Pad example — not a
template. It shows the loop turning exactly once, end to end, so you can see what
the files look like in practice before adapting the kit to your own repo.

The scenario: the investor demo needs a way to replay the full
Pad → Bus → agents → Cockpit story. Beacon spots it, Watchtower claims it, the
Project Lead approves it, Watchtower ships it, and Beacon records the lesson.

---

## Read it in this order

1. **`LOOP_RADAR.md`** — start at the top. Beacon's morning scan ranked
   **P0 #1 Demo coherence** as the thing that matters most. (The radar here is
   shown *after* the iteration, so that factor is already 🟢 with the shipped
   work noted. The dashed quote at the top flags that.)

2. **`agents-status/task-briefs/001-cockpit-demo-replay.md`** — Beacon turned
   that radar factor into one concrete, bounded task brief. Note `Status:
   CLAIMED` and the **Agent response** block at the bottom where Watchtower says
   "I can take this." Beacon wrote this. Beacon did **not** approve it.

3. **`agents-status/approvals/001-watchtower-demo-replay.md`** — Watchtower could
   not just start coding (the task changes user-facing demo behavior, so approval
   is required). It created this request as `PENDING`, scoped tightly to
   `apps/cockpit/**`. Scroll to **Operator decision**: the Project Lead approved
   it with one real constraint — read the fixture at runtime, don't vendor a copy.

4. **`agents-status/watchtower.md`** — the coding agent's journal *after*
   shipping. "Just shipped" lists the replay work, the tests it ran, and the PR.
   "Notes" confirms it honored the Project Lead's constraint.

5. **`agents-status/beacon.md`** — the loop agent's side: what it observed, the
   brief and approval it created, and that demo coherence moved 🟡 → 🟢. Note it
   created only one P0 brief, not three, because only one was clean enough.

6. **`LOOP_MEMORY.md`** — the "Beacon learns" step that closes the loop. The
   Project Lead's runtime-fixture decision is recorded as durable, plus a lesson:
   the cleanest P0 briefs sit inside one owned path.

---

## The loop you just traced

```txt
LOOP_RADAR.md          observe + rank   → "Demo coherence is the P0"
  → task-briefs/001    propose          → Beacon briefs one bounded task
  → approvals/001      approve           → Watchtower requests, Project Lead grants
  → watchtower.md      execute + verify  → built, tested, PR opened, journal updated
  → LOOP_MEMORY.md     learn             → decision + lesson recorded
  → back to the radar  observe again
```

---

## What to notice

- **Authority stayed split the whole way.** Beacon suggested and drafted. The
  agent requested and built. Only the Project Lead approved. No step let an
  agent approve its own work or cross an ownership boundary.
- **Everything is a file.** No coordination happened in chat. The brief, the
  approval, the decision, and the lesson are all in the repo, reviewable in a PR.
- **The work fit inside one owned path.** That is *why* it was a clean P0. Tasks
  that span Pad + Bus + contracts would have gone through a proposal first.

---

## The other half: when to propose instead of brief

Not everything important becomes a task brief. Some things need an architectural
decision *before* any code. The example includes one worked case:

- **`agents-status/proposals/001-contract-version-field.md`** — Conduit wanted to
  add an optional `schemaVersion` field to the frozen IAIP contract. Because that
  changes a type every agent depends on, it was raised as a **proposal**, not a
  task brief. The Project Lead reviewed the options and **deferred** it to the
  planned contract audit. The decision is recorded in `LOOP_MEMORY.md`.

The rule of thumb:

```txt
fits in one owned path, bounded   → task brief → approval → build
crosses boundaries or contracts   → proposal → Project Lead decision → maybe later a brief
```

Beacon's job is to know the difference and not turn every important thing into a
task.

To adapt this to your repo, copy the shapes of these four files, not the
contents. Start your own iteration from your `LOOP_RADAR.md`.
