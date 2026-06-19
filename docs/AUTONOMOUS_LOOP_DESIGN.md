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

## Why not Option A, even "scoped" (a correction)

An earlier draft of this doc proposed shipping **Option A scoped to pre-approved
briefs** as the smallest useful step. On review that's wrong, and the reason is worth
stating plainly because it's easy to get backwards:

**In this kit, isolation is a physical property, not an instruction.** It exists
because each agent is a *separate process* with a *separate working directory* and a
*separate permission grant*, watched in a *separate window*. Option A's fan-out
subagents share one session's context and — critically — one permission grant. A tool
permission the operator approved for agent A's task is live for agent B. So:

- **"Worktree pinning" via a prompt rule is wishful.** "Write only inside your owned
  paths" is an instruction the agent can ignore, exceed, or be argued out of — the
  exact trust-the-agent model the kit *forbids* for self-approval, smuggled back in for
  self-confinement. Real pinning needs OS-level confinement (a process that literally
  cannot write outside its dir, or a non-overridable pre-write reject hook), which
  fan-out-in-one-session does not give you.
- **"Pre-approved briefs only" gates entry, not blast radius.** Requiring
  `Status: APPROVED` before dispatch genuinely prevents auto-approving *new* work —
  keep that. But an approved brief authorizes a *bounded change in owned paths*; it does
  not bound what the agent emits once running, and in fan-out there's no human watching
  that window in real time.

So Option A doesn't *weaken* isolation; it removes the mechanism that produced it. It's
acceptable only for a throwaway, fully-sandboxed batch — not as the steady-state loop.

## Proposed first step: Option B, scoped to pre-approved briefs

Ship a **supervisor**, as a *separate opt-in plugin* (not this one — see below), that
keeps process-per-agent:

1. Read `LOOP_RADAR.md` + `agents-status/task-briefs/*` and select only briefs whose
   matching approval in `agents-status/approvals/` is **already** `Status: APPROVED`.
   Anything not pre-approved is skipped and **logged loudly** — never auto-approved.
2. For each selected brief: ensure the agent's worktree exists (reuse `spawn-agent.sh`),
   then launch a **separate `claude -p` headless run, pinned to that worktree directory
   with its own permission scope** — not a subagent in the supervisor's session. The
   per-process working dir is the OS-level confinement Option A lacks.
3. Collect each agent's journal write + open a PR per branch. **Never merge.**
4. Emit a single operator briefing (reuse the `/loop:tick` synthesis) and **stop** —
   handing control back to the human for merges and any new approvals.

This gets the 80/20 the kit actually wants (automate dispatch of already-blessed work)
*without* surrendering the isolation primitive: one agent = one process = one working
dir = one permission grant, and a supervisor that is structurally incapable of editing
code or approving anything. "More moving parts" (process lifecycle, log capture) is the
price of the safety mechanism, not overhead to optimize away.

### Guardrails any version must enforce
- **No auto-approval.** The supervisor may *read* approval state, never write it.
- **Process-level confinement.** Each agent runs as its own process pinned to its
  worktree dir with its own permission grant — not a shared-session subagent.
- **PR-gated.** Output is always a branch + PR a human merges, never a push to base.
- **Loud truncation.** If the run caps agents or skips briefs, it says so.
- **Stale = stop, not retry-forever.** Define the detector and clock explicitly
  (reuse `LOOP_STALE_HOURS` from `status.sh`); a wedged agent surfaces, it is not
  silently respawned in a loop.

### Failure modes to design for (mostly absent in the Option-A framing)
- **Shared-file contention.** N agents + the supervisor read/write `LOOP_RADAR.md`,
  journals, and approval files; coordination is last-writer-wins markdown with no
  locking. Concurrent journal writes interleave. Give each agent its own file and
  never let two processes write the same one.
- **Approval-file races.** Agents create approval requests with numeric prefixes
  (`001-…`); N concurrent creators can collide on the same prefix. Need atomic
  allocation (e.g. content-hash or UUID names, not sequential ints).
- **All-blocked deadlock.** If every agent stops on an unapproved boundary, the
  supervisor has nothing to collect and no human is in the loop. Detect "all agents
  blocked" and exit to the human — don't spin.
- **Context / cost blowup.** Per-process runs avoid the shared-context-window
  exhaustion of fan-out, but still need a per-agent token/cost budget and a kill
  switch; name them.
- **Partial-dispatch state.** The run can die after opening 3 of 6 PRs. Make dispatch
  idempotent/resumable (skip briefs whose branch+PR already exist).

## Resolved questions
1. *Is Option A-scoped-to-approved safe enough?* **No** — sharing one session's
   permission scope across fan-out agents breaks isolation regardless of "pinning."
   Use Option B (process-per-agent).
2. *Is worktree pinning enforceable for subagents?* **Not via instruction.** It needs
   OS-level per-process confinement, which Option B provides and Option A does not.
3. *In this plugin or a separate one?* **Separate, opt-in plugin.** The default install
   must stay strictly human-in-the-loop; autonomy is an explicit, separately-installed
   choice.
