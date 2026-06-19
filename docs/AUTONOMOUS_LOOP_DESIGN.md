# Follow-up design: an autonomous "operator-drives-the-agents" mode

> Status: **proposal / not built.** This sketches an optional autonomy layer on top
> of the plugin scaffold (see `.claude-plugin/`, `commands/`, `skills/`). The kit
> today is deliberately human-in-the-loop: the plugin scaffolds worktrees and reads
> state, but a human opens each agent's AI window and approves risky work. This doc
> describes what it would take to let one operator session *drive* the agents, and
> — just as importantly — where that trades away the kit's core safety property.

## The property we must not lose

The kit's value is **isolation + supervision**:

- *one agent = one worktree = one branch = one AI window* — agents physically cannot
  edit each other's files, so a bad agent corrupts one branch, never the tree;
- *nothing self-merges* — agents stop and write an approval request before crossing
  an ownership boundary or a frozen contract; the human is the only actor who can
  say "approved / merge / ship despite failing" (see `PROTOCOL.md`).

Any autonomy layer is only worth shipping if it keeps both. The failure mode to
design against is an orchestrator that quietly becomes the approver — at which point
the "loop" is just an unsupervised agent swarm with extra files.

## Two honest options for "more autonomous"

### Option A — Subagent fan-out (fast, weaker isolation)

One operator session uses Claude Code's subagent / background-task tooling to run
N coding agents itself, one per task brief.

- **Pros:** no second window per agent; the operator can dispatch, collect journals,
  and re-rank in a single loop. Cheapest to build — it's a skill plus a fan-out.
- **Cons:** subagents share the operator's session, permissions, and (by default)
  working directory. The per-worktree filesystem isolation is gone unless each
  subagent is pinned to its own worktree path and refuses writes outside it. The
  human-approval gate has to be re-imposed *in software* (the orchestrator must
  block on approval files), because there's no longer a human watching each window.
- **Verdict:** good for a *bounded, pre-approved* batch ("apply these 6 briefs that
  I already approved, each in its own worktree, open 6 PRs"). Not good as the
  steady-state loop, because it concentrates suggest+approve+execute in one actor.

### Option B — Supervisor that opens real agent sessions (slower, keeps isolation)

The operator session stays a *supervisor*: it ranks work, spawns worktrees, and
launches a **separate** headless Claude Code run per agent (`claude -p` pinned to the
worktree dir + the agent prompt), then watches journals/PRs and never edits code itself.

- **Pros:** preserves *one agent = one worktree = one process*; each agent has its own
  permission scope; the supervisor is structurally incapable of being the coder.
- **Cons:** more moving parts (process lifecycle, log capture, restart-on-stale);
  headless sessions still need an approval channel back to a human for anything
  crossing a boundary.
- **Verdict:** the right shape if the goal is genuine autonomy without losing the
  safety model. It's a real feature, not a skill — closer to a daemon.

## Proposed first step (smallest thing that's actually useful)

Ship **Option A, scoped to pre-approved briefs only**, as a new skill
`skills/run-approved-briefs/`:

1. Read `LOOP_RADAR.md` + `agents-status/task-briefs/*` and select only briefs whose
   matching approval in `agents-status/approvals/` is **already** `Status: APPROVED`.
   Anything not pre-approved is skipped and listed — never auto-approved.
2. For each selected brief: ensure the agent's worktree exists (reuse `spawn-agent.sh`),
   then run one coding agent **pinned to that worktree path**, handed the brief + the
   agent's prompt + a hard rule: *write only inside your owned paths; if you hit an
   unapproved boundary, write an approval request and stop.*
3. Collect each agent's journal write + open a PR per branch. Never merge.
4. Emit a single operator briefing (reuse the `/loop:tick` synthesis) and **stop** —
   handing control back to the human for merges and any new approvals.

This keeps the invariant (no self-approve, no self-merge, PR-gated) while removing the
"open N windows by hand" cost for work the operator already blessed. It's the 80/20:
the tedious part (dispatching approved work) is automated; the dangerous part
(approving, merging, crossing boundaries) stays human.

### Guardrails any version must enforce
- **No auto-approval.** The orchestrator may *read* approval state, never write it.
- **Worktree pinning.** Every agent process is constrained to its worktree dir;
  writes outside owned paths are rejected, not merged.
- **PR-gated.** Output is always a branch + PR a human merges, never a push to the
  base branch.
- **Loud truncation.** If the run caps agents or skips briefs, it says so — silent
  caps read as "did everything" when it didn't.
- **Stale = stop, not retry-forever.** A wedged agent surfaces on the board; it does
  not get silently respawned in a loop.

## Open questions for review
1. Is Option A-scoped-to-approved a safe enough default, or does sharing one session's
   permissions across fan-out subagents already break the isolation promise too much?
2. Worktree pinning for subagents — enforceable today via tooling, or does it need a
   per-agent sandbox we don't have?
3. Should the autonomy layer live in *this* plugin, or as a separate opt-in plugin so
   the default install stays strictly human-in-the-loop?
