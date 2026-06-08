# Setup Interview (read me first, agent)

**This file is addressed to a coding agent, not the user.** If you are an AI
coding agent and you find this kit in a repo (or are pointed at it), read this
file first. It tells you what the kit is and how to set it up for *this specific
project* by interviewing the user — not by guessing.

---

## What this kit is

The Multi-Agent Loop Kit is a file-based operating model for running several AI
coding agents in one repo in a continuous, human-approved loop:

```txt
observe → rank → propose → approve → execute → verify → repeat
```

It is configured through markdown files, not code. To make it work in this repo,
those files must describe THIS project: its build objective, its path ownership,
its frozen contracts, and its test gates. Right now they hold generic
placeholders. Your job is to replace those with real values from the user.

You must not invent the project's direction or ownership. You ask; the user
decides. You configure from their answers; you stop for approval before anything
irreversible (starting agents, creating worktrees).

---

## How to run the setup

### Step 1 — Look before you ask

Read the repo's actual shape so your questions are concrete, not generic:

- top-level directories, `apps/*`, `packages/*`, services
- `package.json` / build files / test commands already present
- any existing `AGENTS.md` the user already had (don't discard it — merge)
- **any project plan / tech spec / design system already in the repo** (e.g.
  `SPEC.md`, `docs/spec*`, a PRD, a design-tokens file). The agents will read
  these; note where they live.

If you find **no plan or spec**, stop and say so plainly before configuring
anything: this kit coordinates execution, it doesn't decide what to build. Ask
the user whether a plan/spec exists elsewhere, or recommend they write one first
(point them at `docs/PREPARING_YOUR_SPEC.md`). Don't generate an ownership map
for an unspecified project — you'd just be guessing.

### Step 2 — Interview the user

Ask these **one or two at a time**, not all at once. Use what you found in
step 1 to make each question specific (e.g. "I see `apps/web` and `apps/api` —
should those be two separate agents?").

1. **Build objective.** What are you building right now, in one sentence?
   (Goes into `LOOP_RADAR.md` as the current objective.)
2. **Project Lead.** Who is the human with final approval — you, or a named
   role/team? (Goes into `AGENTS.md`.)
3. **How many agents.** Realistically, how many parallel coding agents does this
   work need — 1, 3, 5? (If the answer is 1, tell them the loop overhead may not
   be worth it yet and suggest starting with one agent + the docs as templates.)
4. **Ownership split.** For each agent, which top-level paths does it own? Every
   path must have exactly one owner, and owners must be disjoint. (Goes into the
   `AGENTS.md` ownership table and `.cursor/rules/01-ownership.mdc`.)
5. **Project-Lead-only files.** Which files should only the Project Lead edit
   (specs, configs, infra)?
6. **Frozen contracts.** Which types/schemas/API contracts must not change
   without a proposal? Where do they live? (Goes into
   `.cursor/rules/02-contracts-frozen.mdc`.)
7. **Test gate.** What commands prove a change is safe in this repo
   (`npm test`, `bun typecheck`, `pytest`, `cargo test`, ...)? (Goes into the
   agent prompts and PR checks.)
8. **Conventions.** Confirm branch prefix `<codename>/<slug>` and commit prefix
   `<codename>:` are fine, or adjust.

If the user can't answer the ownership questions yet, say so plainly: the kit
only pays off when work can be partitioned by path. Recommend they start with a
single agent until boundaries are clear.

### Step 3 — Generate the configuration

From the answers, fill in (do not leave placeholders):

- `AGENTS.md` — Project Lead, the ownership table, frozen contracts. Merge with
  any existing `AGENTS.md` rather than replacing it.
- `.cursor/rules/01-ownership.mdc` — the same ownership map.
- `.cursor/rules/02-contracts-frozen.mdc` — the frozen paths.
- `LOOP_RADAR.md` — the one-sentence build objective.
- one journal per agent (`agents-status/<codename>.md`) and one prompt per agent
  (copy `prompts/coding-agent.md` → `prompts/<codename>.md` and fill identity).

### Step 4 — Present and stop

Show the user the proposed `AGENTS.md` ownership table and `LOOP_RADAR.md`
objective as a **proposal**. Ask them to confirm or correct. Do not start any
agents, create any worktrees, or run any product code until they approve.

After approval, point them to the README "Start Beacon" and "Start coding
agents" steps.

---

## The one rule that survives setup

Even while configuring, the authority split holds: **you suggest and draft, the
user decides.** Ownership and product direction are theirs. If you're unsure
whether something is a setup detail or a product decision, treat it as a product
decision and ask.
