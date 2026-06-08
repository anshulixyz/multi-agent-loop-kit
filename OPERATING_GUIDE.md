# Operating Guide

How a human and AI agents run a repo as a multi-agent loop — step by step. This
is the core of the kit. Installing files is a footnote; *this* is the method.

The whole system rests on one split of authority:

```txt
Beacon suggests.  Agents interpret.  Project Lead approves.  Agents build.  Standup verifies.
```

- **Project Lead** — the human. Owns direction, ownership boundaries, frozen
  contracts, and every approval. The only one who can say "yes, build this."
- **Beacon** — a non-coding agent that watches the repo and ranks what matters
  next. Suggests; never approves, never writes product code.
- **Coding agents** — each owns a disjoint set of paths, works in its own git
  worktree, and only builds what's approved.

---

## Step 1 — Break the work into agents (human + agent, together)

This is a conversation, not a config file you fill in alone. Point your coding
agent at `prompts/setup-interview.md` and work through it together. The goal is
to answer four questions:

1. **What are we building?** One concrete objective → `LOOP_RADAR.md`.
2. **How does the code partition?** List the repo's real top-level surfaces
   (`apps/web`, `apps/api`, `packages/*`, services). Each becomes a candidate
   agent. The rule: **every path has exactly one owner, and owners don't
   overlap.** If two agents would touch the same directory, split it or merge the
   agents.
3. **What's frozen?** Which types/schemas/contracts must not change without a
   decision → `.cursor/rules/02-contracts-frozen.mdc`.
4. **How many agents?** 1, 3, 5? More agents = more coordination cost. If the
   work doesn't cleanly partition, use fewer agents (or one) until it does.

The agent should *propose* the split by reading your repo; you decide it. Write
the result into `AGENTS.md` (the ownership table) and
`.cursor/rules/01-ownership.mdc`.

> Task breakdown lives at two levels: **structural** (which agent owns which
> paths — done once, here) and **per-cycle** (what each agent does next — done
> continuously by Beacon in Step 3). Don't confuse them. This step sets the
> boundaries; Beacon fills them with work later.

---

## Step 2 — Give each agent its prompt

Each coding agent is just an AI session that has been told who it is. Create one
prompt per agent from the template:

```bash
cp prompts/coding-agent.md prompts/frontend.md
cp prompts/coding-agent.md prompts/backend.md
```

In each, fill the identity block: codename, role, **owned paths**, branch prefix
(`<codename>/<slug>`), commit prefix (`<codename>:`). That prompt is the agent's
whole contract — it tells the agent what it may touch, what to read at session
start, when to stop and ask for approval, and what "done" means.

Then create one journal per agent so it has somewhere to report state:

```bash
cp agents-status/JOURNAL_TEMPLATE.md agents-status/frontend.md
```

And one isolated workspace per agent:

```bash
bun run spawn frontend day-1   # → ../<repo>-frontend on branch frontend/day-1
```

One agent, one prompt, one journal, one worktree, one AI window. That isolation
is what lets them run in parallel without colliding.

---

## Step 3 — Run the loop

### Attaching Beacon

Beacon is not a daemon and not a background service. **It is an AI session you
open in your main workspace with the Beacon prompt loaded.** That's the whole
"attachment":

```txt
Read prompts/beacon.md and follow it exactly.
```

Beacon then reads the repo, journals, and open PRs and writes `LOOP_RADAR.md`
(ranked "what matters next") plus task briefs in `agents-status/task-briefs/`. It
does not approve and does not write product code.

**How often to run it — the cadence.** Run Beacon at *loop boundaries*, not
continuously:

- at the start of a working session, to set the day's radar;
- after a batch of PRs merges (the repo state changed, so the ranking should);
- whenever an agent reports `BLOCKED` and you want the next-best work surfaced.

Two ways to keep it attached:

- **One-shot (simplest):** open a fresh Beacon session each boundary, let it
  update the radar, close it. State lives in the files, not the session, so
  nothing is lost.
- **Held session:** keep one Beacon session open and just say `re-scan` after
  merges. Same effect; saves re-pasting.

Do **not** run Beacon on a tight timer (every few minutes). It re-ranks state;
if state hasn't changed, you're spending tokens for nothing. The loop advances
when work merges, not when the clock ticks.

> You can run more than one Beacon (a repo-wide one, a frontend one, etc.) — see
> `docs/FUTURE_BEACON_INTEGRATIONS.md`. They all observe and suggest; none
> approve.

### One turn of the loop

1. **Beacon** ranks and briefs (above).
2. **Each coding agent**, in its own worktree, reads the radar and briefs and
   decides: my owned path? aligned with the objective? approval needed? If
   approval is needed and missing, it writes an approval request and **stops**.
3. **You (Project Lead)** review pending approvals — approve, reject, or narrow.
4. **Approved agents** build on their branch, run tests, update their journal,
   open a PR.
5. You merge clean PRs; Beacon re-scans. That's one turn.

The distinction that keeps it safe:

- **Task brief** — fits inside one owned path, bounded → brief → approval →
  build.
- **Proposal** — crosses boundaries or changes a frozen contract → Project Lead
  decision *before* any code. (See `examples/intent-pad/` for a worked one.)

---

## Step 4 — See what's happening (status + reports)

Agents report by writing their journal (`agents-status/<codename>.md`) at session
start, when blocked, after shipping, and before stopping. You never have to ask
an agent for a status — you read the files, or run one command.

**The board — what every agent is doing right now:**

```bash
bun run status        # or: bash tools/loop/status.sh
```

It prints, per agent: branch, when the journal was last updated (with a **STALE**
flag if an agent has gone quiet), what it's doing now, what it's blocked on,
what's next, and what it just shipped — plus a one-line summary
(`5 agents · 4 idle · 1 blocked`). This is your first glance every session.

**The full surfaces:**

| Want to know... | Command | Reads/writes |
|---|---|---|
| What every agent is doing + who's stale | `bun run status` | all journals |
| What matters next | `bun run loop:radar` | `LOOP_RADAR.md` |
| What's waiting on your approval | `bun run loop:approvals` | `agents-status/approvals/*` |
| Who's blocked / decisions you owe | `bun run standup` | writes `BLOCKERS.md`, `OPERATOR_ASKS.md` |
| What one agent can safely do next | `bun run loop:listen frontend` | radar + that agent's briefs |
| Git state of every worktree | `bun run agents` | `git worktree list` |
| Everything at once | `bun run loop` | status board → scan → radar → standup |

None of these run agents — they summarize files. The loop itself advances
through the AI sessions in Step 3. If an agent shows **STALE**, its session
probably ended; re-open it (or spawn a fresh one) and point it at its prompt.

> **The board is only as honest as the journals.** It reads
> `agents-status/<codename>.md`, so if an agent forgets to update its journal,
> the board will show stale or wrong state. Two safeguards: the `coding-agent.md`
> prompt requires a journal write before stopping (it's in the agent's
> definition of done), and the **STALE** flag catches agents that have gone
> quiet. Treat the board as a high-signal summary, not ground truth — when in
> doubt, `bun run agents` shows real git state, and the PRs show what actually
> landed.

---

## The daily rhythm

```txt
1. bun run status          # who's doing what, who's blocked, who's stale
2. bun run loop:approvals  # what's waiting on you → approve / reject / narrow
3. let approved agents build, test, PR
4. merge clean PRs
5. open/refresh Beacon → re-scan and re-rank
6. repeat
```

Keep it light. If the process feels heavier than the work it coordinates, you
have too many agents — drop back to fewer until the work justifies them.

When something doesn't go to plan — an agent gets stuck, needs a frozen-contract
change, finishes early, or a demo breaks — see **[`RUNBOOK.md`](RUNBOOK.md)** for
the scenario-by-scenario playbook.
