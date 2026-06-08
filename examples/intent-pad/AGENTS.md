# Intent Pad Agent Preset

This is the named-agent preset from the original Project Lead's Intent Pad workflow.

Use this as the canonical example when adapting the Multi-Agent Loop Kit to a real multi-surface product.

---

## Operator

| Codename | Owns | Role |
|---|---|---|
| **Project Lead** | Spec, contracts, runbook, prompts, `.cursor/rules/**`, final approvals | Product owner and sole decider for cross-cutting changes |

Project Lead owns:

- Product decisions
- Demo objective
- Shared contracts / schemas / types
- Final approval requests
- Proposal decisions
- Merge decisions
- Agent ownership changes

---

## Beacon

| Codename | Owns | Role |
|---|---|---|
| **Beacon** | `LOOP_RADAR.md`, `LOOP_MEMORY.md`, `agents-status/beacon.md`, `agents-status/task-briefs/**`, creation of `agents-status/approvals/**`, `tools/loop/**` | Loop radar, task intelligence, build-factor updates |

Beacon sees. Beacon suggests. Beacon never approves. Beacon never codes product features.

---

## Coding agents

| Codename | Owns | Role | Branch prefix | Commit prefix |
|---|---|---|---|---|
| **Anvil** | `apps/pad/**` | iOS Pad app | `anvil/<slug>` | `anvil:` |
| **Conduit** | `apps/bus/**`, `packages/iaip-mocks/**`, `packages/bus-client/**` | Protocol Bus + shared client | `conduit/<slug>` | `conduit:` |
| **Forager** | Grocery agents + `packages/agent-kit/**` | Blinkit / Instacart style agents | `forager/<slug>` | `forager:` |
| **Reel** | Media agents | YouTube / Instagram style agents | `reel/<slug>` | `reel:` |
| **Watchtower** | `apps/cockpit/**` | Mac-side live dashboard | `watchtower/<slug>` | `watchtower:` |

---

## Ownership hard rule

An agent never commits outside owned paths.

Cross-boundary needs go through one of:

1. journal task for owning agent
2. approval request
3. proposal
4. Project Lead decision

---

## Worktree map

```txt
~/Documents/IAIP-demo-mobile/          # canonical clone
~/Documents/intent-pad-operator/        # operator, usually main
~/Documents/intent-pad-anvil/          # Anvil branch
~/Documents/intent-pad-conduit/        # Conduit branch
~/Documents/intent-pad-forager/        # Forager branch
~/Documents/intent-pad-reel/           # Reel branch
~/Documents/intent-pad-watchtower/     # Watchtower branch
~/Documents/intent-pad-beacon/         # Beacon branch
```

---

## Spawn order

Recommended order after Day 0 contracts land:

1. Conduit — publishes mocks and bus client
2. Forager — publishes agent kit
3. Anvil, Reel, Watchtower — parallel once mocks/client exist
4. Beacon — can run anytime after journals exist, but becomes most useful after at least two agents are active

---

## Loop principle

```txt
Beacon sees.
Agents interpret.
Project Lead approves.
Agents build.
Standup verifies.
Beacon learns.
```
