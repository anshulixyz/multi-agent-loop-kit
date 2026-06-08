# Safe auto-mode

"Auto-mode" here means: an approved coding agent keeps working through its owned,
numbered slices **without you re-prompting each step** — not unattended autonomy.
The difference is entirely in the boundaries below. The kit's value is that these
boundaries are explicit and enforced by the agent's prompt, the ownership rules,
and your approval gate.

This doc is the contract. It restates, in one place, what the `coding-agent.md`
prompt and `PROTOCOL.md` already require.

---

## What safe auto-mode lets an agent do

An agent in auto-mode may, on its own, repeatedly:

- work **only** on tasks that are already **approved**
- touch **only** files inside its **owned paths**
- work in **small numbered slices**, one at a time
- run the slice's **test** before moving on
- **commit** each slice with its prefix and **update its journal**
- open a **PR** when a coherent chunk is done
- pick the next approved, owned slice and continue

That's the loop running without a human in the keystrokes — but every slice is
inside lines you drew.

---

## What it must NOT do (stop and ask instead)

An agent must stop and request a decision — never decide these itself — before:

- working on an **unapproved** product task
- editing **outside its owned paths**
- changing a **frozen contract / shared schema / types**
- adding a **new dependency**
- touching **auth, security, or data** behavior
- a **large or cross-cutting refactor**
- anything that affects **another agent's** files
- continuing past its **stop conditions** (below)

When in doubt, it treats the action as requiring approval and asks.

---

## Stop conditions (every auto-mode run needs them)

An agent does not run forever. It stops and hands back to you when any of these
fire:

- **No approved owned work left** — go idle, don't invent scope.
- **Max slices reached** — set a ceiling per run (e.g. "stop after N slices").
- **Token / time budget reached** — loops cost money; cap it.
- **The 3-attempt rule** — a slice's test failed three times → journal, surface,
  move on or stop.
- **Uncertainty** — ownership unclear, spec ambiguous, or a decision is needed.
- **A test gate is red** on shared/main — treat as urgent, stop feature work.

State the ceiling explicitly when you start an agent, e.g.:

```txt
Work your approved slices in auto-mode. Stop after 6 slices, if a test fails 3×,
if you'd touch anything outside apps/web/**, or if you need a decision.
```

---

## Why this is safe and not hype

Three things keep auto-mode honest:

1. **Approval gate** — agents execute approved work; they don't choose product
   direction.
2. **Ownership boundary** — an agent physically works in its own worktree and
   owned paths; it can't quietly edit across the repo.
3. **Stop conditions + journals + PRs** — the run is bounded, logged, and
   reviewable. Nothing merges without you.

Remove any one of these and "auto-mode" becomes "unattended autonomy," which this
kit deliberately does not do.
