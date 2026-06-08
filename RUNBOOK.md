# Runbook — what to do when

`OPERATING_GUIDE.md` covers the happy path (set up, run the loop, see status).
This file is for when reality deviates: the situations that actually come up
during a multi-agent build, each as **trigger → who decides → steps**. It's a
lookup table, not a read-through. The Project Lead decides everything here.

---

## 01 — An agent needs a field that doesn't exist in a frozen contract

**Trigger:** an agent's journal flags a missing type/field in a frozen/shared
package.
**Decides:** Project Lead.
**Steps:**
1. The agent writes a proposal (`agents-status/proposals/NNN-<slug>.md`) — it does
   **not** edit the contract itself.
2. You decide: accept (with constraints), reject (with reason), or defer.
3. If accepted, *you* (or the contract owner) make the change on your own branch,
   add a test proving the new shape, and merge.
4. Record the decision in the proposal file and `LOOP_MEMORY.md`.
5. Ping the affected agents in their journals: "contract changed — pull and
   continue." They pull, re-typecheck, and resume.

---

## 02 — One agent needs another to build something first

**Trigger:** Agent A is blocked on a route/module Agent B owns.
**Decides:** the owning agent (B) prioritizes; Project Lead only if it's contested.
**Steps:**
1. A leaves a note in B's journal (or a task brief), not a direct edit of B's code.
2. A keeps moving on independent slices, working against a **mock** in the
   meantime (see 03).
3. B treats the unblock as high priority — "unblock others first" is in the
   agent prompt.

---

## 03 — An agent needs mock data another agent owns

**Trigger:** A needs a fixture/mock to proceed without B's real implementation.
**Decides:** the mock's owner (no Project Lead needed — mocks aren't product).
**Steps:**
1. The owner adds the mock to the shared mocks package/dir and commits.
2. A consumes it and continues. Mocks-first means no agent waits on another's real
   code.

---

## 04 — An agent is stuck (3-attempt rule fired)

**Trigger:** a slice's test failed three times.
**Decides:** the agent self-triages; Project Lead if it needs a decision.
**Steps:**
1. The agent stops on that slice, writes what it tried in its journal, and
   surfaces it (blocker note, or approval/proposal if a decision is needed).
2. It moves to the next *independent* slice rather than grinding.
3. You see it on `bun run status` (blocked) or `bun run standup`. Unblock or
   reprioritize.

---

## 05 — An agent finished its work and asks what's next

**Trigger:** an agent reports idle on the status board.
**Decides:** Beacon proposes; Project Lead approves.
**Steps:**
1. Run Beacon to re-scan — it ranks the next work and may write a task brief.
2. The agent self-selects an owned, aligned brief and files an approval if needed.
3. If there's genuinely no owned work left, the agent stays idle (that's fine —
   don't invent scope to keep it busy).

---

## 06 — An agent thinks its own prompt is wrong

**Trigger:** an agent flags that its instructions conflict with reality.
**Decides:** Project Lead.
**Steps:**
1. The agent surfaces the issue in its journal — it does **not** rewrite its own
   prompt to expand its scope.
2. You edit `prompts/<codename>.md`, commit, and tell the agent: "prompt updated —
   re-read `prompts/<codename>.md` before continuing."

---

## 07 — Reviewing PRs from agents

**Trigger:** an agent opens a PR.
**Decides:** Project Lead (you merge).
**Steps:**
1. Check the PR body has owned-paths, tests run, and coordination impact (the
   template + CI enforce this).
2. Confirm every changed file is inside that agent's owned paths, or an
   approval/proposal is linked (`bun run ownership:check` lists changed files).
3. Merge clean PRs; request changes otherwise. Then re-run Beacon so the radar
   reflects the new state.

---

## 08 — Cutting a feature mid-build

**Trigger:** you decide to drop a surface/agent.
**Decides:** Project Lead.
**Steps:**
1. Mark the related task briefs `DISCARDED` and any approvals `EXPIRED`.
2. Record why in `LOOP_MEMORY.md` so it doesn't get re-proposed.
3. Tell the affected agent in its journal; stop its worktree.

---

## 09 — Adding a new agent

**Trigger:** the work grows a new, disjoint surface.
**Decides:** Project Lead.
**Steps:**
1. Confirm the new owned paths are disjoint from every existing owner (split a
   directory or merge roles if not).
2. Add it to the `AGENTS.md` ownership table and `.cursor/rules/01-ownership.mdc`.
3. `cp prompts/coding-agent.md prompts/<codename>.md`, fill its identity, create
   its journal, spawn its worktree.

---

## 10 — Recording a decision for the future

**Trigger:** you made a call that future-you (or an agent) should not relitigate.
**Decides:** Project Lead.
**Steps:** add it to `LOOP_MEMORY.md` — the decision, why it stays true, and a
trace to the proposal/approval. Beacon reads this and won't re-surface settled
questions.

---

## 11 — Release / demo-day failure

**Trigger:** something breaks during a live run.
**Decides:** Project Lead, fast.
**Steps:**
1. Don't start a loop mid-incident. Fix it yourself or hand one agent a single
   scoped task.
2. After, write what broke in `LOOP_MEMORY.md` and, if it's recurring, a task
   brief to harden it.

---

## 12 — "main is already checked out" (worktree branch hygiene)

**Trigger:** git refuses `git checkout main` in a worktree because another
worktree holds `main`.
**Decides:** n/a (git rule).
**Steps:** only one worktree can hold `main` at a time. In the others, don't fight
it — branch the next slice straight from the remote:
```bash
git fetch origin main
git checkout -b <codename>/<next-slice> origin/main
```
Keep the Project Lead's worktree on `main` (it's the review view); coding
worktrees live on their `<codename>/<slug>` branches.

---

## The four communication channels (don't blur them)

| Channel | For | Default? |
|---|---|---|
| Journal (`agents-status/<codename>.md`) | day-to-day state + flagging things | **yes — default** |
| Proposal (`agents-status/proposals/*`) | a decision you must make | escalation |
| PR review comments | code-level discussion on one change | as needed |
| Issues | cross-cutting bugs / things that outlive the build | escape hatch |

Agents talk to themselves in their journal by default. Going to a proposal or
issue is a deliberate escalation, not a habit — the whole point of the design is
that agents minimize chatter.
