# Prompts README

This folder contains prompts for the operator, Beacon, and coding agents.

---

## Prompt types

| Prompt | Purpose |
|---|---|
| `setup-interview.md` | **Read first when setting up.** Agent-directed: read the kit, interview the user, and fill in `AGENTS.md` / ownership rules / `LOOP_RADAR.md` for their project. |
| `beacon.md` | Loop intelligence agent. Scans, ranks, creates task briefs and approvals. Does not code. |
| `coding-agent.md` | Generic prompt for any coding agent. Duplicate per codename. |
| `operator.md` | Operator copilot prompt for reviewing approvals, proposals, and PRs. |

---

## Recommended usage

For Beacon:

```txt
Read prompts/beacon.md and follow it exactly.
Treat the content below the --- as your operating instructions.
```

For coding agents:

```txt
Read prompts/coding-agent.md and follow it exactly.
Apply it as codename: <codename>.
Owned paths:
- <path>
- <path>
```

Better:

```bash
cp prompts/coding-agent.md prompts/frontend.md
cp prompts/coding-agent.md prompts/backend.md
```

Then customize each file.

---

## Prompt rules

Every coding agent prompt should include:

1. Identity
2. Owned paths
3. Files to read first
4. Worktree/branch convention
5. Loop listening instructions
6. Approval gate
7. Test gate
8. Journal update rule
9. Definition of done
10. Stop conditions

---

## Session reset rule

Use a fresh chat when:

- switching codenames
- switching worktrees
- after a major contract decision
- after a failed merge conflict
- after context gets messy

Do not reuse one chat for multiple codenames.
