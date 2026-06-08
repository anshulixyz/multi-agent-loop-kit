# AGENTS.md — Multi-Agent Ownership Registry

> **Setting this kit up in this repo?** If you are an AI agent helping configure
> the kit, read `prompts/setup-interview.md` first — it tells you how to
> interview the user and fill this file in for their project. The contents below
> are a generic template until that interview is done.

This file is the source of truth for who can edit what.

Every coding agent must obey path ownership, journal updates, proposal rules, approval gates, and PR discipline.

---

## Two meanings of “agent”

| Term | Meaning |
|---|---|
| **Coding agent** | A Cursor / Claude / Codex session with a codename, worktree, owned paths, branch prefix, and kickoff prompt |
| **Runtime agent** | An app-level process in your product, e.g. an agent that subscribes to events, calls APIs, or executes user workflows |

This file is about **coding agents**.

---

## Core rules

1. One coding agent per worktree.
2. One worktree per Cursor / Claude / Codex window.
3. Every path has exactly one owner.
4. No coding agent commits outside owned paths.
5. Cross-boundary changes require a proposal or approval request.
6. Shared contracts are frozen and operator-owned.
7. Agents coordinate through journals, task briefs, approvals, and proposals.
8. Agents never coordinate through private chat if the information affects build state.
9. All implementation work happens on `<codename>/<slug>` branches.
10. All meaningful work ends with tests, journal update, and PR.

---

## Project Lead / Operator

| Field | Value |
|---|---|
| Codename | `operator` |
| Human | Project Lead / repo owner |
| Owns | Product decisions, contracts, specs, runbook, rules, final approval |
| Branch | `main` unless intentionally editing |
| Commit prefix | `operator:` |

Project Lead / operator owns:

- `AGENTS.md`
- `OPERATING_GUIDE.md`
- `PROTOCOL.md`
- `RUNBOOK.md`
- `LOOP_RADAR.md` final objective
- `LOOP_MEMORY.md` final decisions
- shared contracts/types/schemas
- `.cursor/rules/**`
- `agents-status/proposals/**` decisions
- `agents-status/approvals/**` decisions

The Project Lead / operator is the only approval authority for:

- Product direction
- Schema / contract changes
- New dependencies
- Architecture shifts
- Cross-agent tasks
- Feature cuts
- Demo flow changes
- Risky refactors

---

## Beacon — loop intelligence agent

| Field | Value |
|---|---|
| Codename | `beacon` |
| Role | Loop radar, build-factor updates, task briefs, approval queue |
| Owns | Loop docs and coordination files |
| Branch prefix | `beacon/<slug>` |
| Commit prefix | `beacon:` |

Beacon owns:

- `LOOP_RADAR.md`
- `LOOP_MEMORY.md`
- `agents-status/beacon.md`
- `agents-status/task-briefs/**`
- `agents-status/approvals/**` creation only, not decisions
- `tools/loop/**`

Beacon does not code product features.

Beacon must never directly edit:

- `apps/**`
- `packages/**`
- product code
- shared contracts
- migration files
- security-sensitive code

Beacon can:

- Read repo state.
- Read journals.
- Read proposals.
- Read approvals.
- Read open PR summaries if available.
- Create or update task briefs.
- Create approval requests.
- Rank build factors in `LOOP_RADAR.md`.
- Update `agents-status/beacon.md`.

Beacon cannot:

- Approve work.
- Merge work.
- Change contracts.
- Assign work as binding.
- Override ownership.

---

## Coding agents

Replace these examples with your repo’s actual agents.

| Codename | Owns | Role | Branch prefix | Commit prefix |
|---|---|---|---|---|
| `frontend` | `apps/web/**`, `components/**` | Web UI | `frontend/<slug>` | `frontend:` |
| `backend` | `apps/api/**`, `server/**` | API/backend | `backend/<slug>` | `backend:` |
| `agentkit` | `packages/agent-kit/**`, `packages/mocks/**` | Agent SDK/mocks | `agentkit/<slug>` | `agentkit:` |
| `ops` | `.github/**`, `infra/**`, `scripts/**` | CI/devops | `ops/<slug>` | `ops:` |

---

## Ownership matrix

Every repo must fill this table before parallel work starts.

| Path | Owner | Notes |
|---|---|---|
| `apps/web/**` | `frontend` | UI only |
| `apps/api/**` | `backend` | API only |
| `packages/types/**` | `operator` | Frozen contract package |
| `packages/mocks/**` | `agentkit` | Mocks for all agents |
| `.github/**` | `ops` | CI workflows |
| `.cursor/rules/**` | `operator` | Persistent agent memory |
| `agents-status/**` | shared by protocol | Each agent edits only its own journal; approvals/proposals follow rules |

---

## Cross-boundary rule

If an agent needs a change outside owned paths, it must choose one:

1. Create a task for the owning agent in its journal.
2. Create an approval request if the change is known and bounded.
3. Create a proposal if the change is architectural, product-level, or contract-level.
4. Ask the operator if ownership is unclear.

Agents must not “just quickly edit” another owner’s file.

---

## Journal rule

Each agent has:

```txt
agents-status/<codename>.md
```

Every journal must use the fixed schema from `agents-status/JOURNAL_TEMPLATE.md`.

Agents update journals:

- session start
- before stopping
- when blocked
- after shipping
- when creating approval/proposal
- when taking or rejecting a Beacon task

---

## Proposal vs approval

Use **proposal** when the operator must decide direction.

Examples:

- Schema change
- Stack change
- Feature cut
- Product behavior change
- New dependency
- Security model
- Major refactor

Use **approval request** when work is already understood but needs permission.

Examples:

- “Build demo replay in cockpit”
- “Add scoped mock fixtures”
- “Refactor this owned module”
- “Wire UI to existing endpoint”

---

## Branch and PR rules

- Branch: `<codename>/<slug>`
- Commit: `<codename>: <imperative message>`
- PR title: `<Codename>: <Title>`
- Never push directly to `main` unless you are the operator and intentionally doing a solo merge.
- PR body must include:
  - What changed
  - Why now
  - Owned paths touched
  - Tests run
  - Coordination impact
  - Approval/proposal link if relevant

---

## Adding a new agent

Add a new agent only when:

1. The new owned path set is disjoint.
2. A kickoff prompt exists.
3. A journal exists.
4. Cursor ownership rules are updated.
5. Worktree spawn script supports the codename.
6. Operator approves the new agent.

If two agents would edit the same directory, split the directory first or merge the roles.
