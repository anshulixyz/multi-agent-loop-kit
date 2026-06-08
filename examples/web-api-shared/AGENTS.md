# AGENTS.md — web + api + shared-types

Source of truth for who owns what. See root `PROTOCOL.md` for the rules and
root `OPERATING_GUIDE.md` for how to run the loop.

## Project Lead

| Codename | Human | Owns | Commit prefix |
|---|---|---|---|
| `operator` | you | direction, approvals, `packages/shared/**` (frozen), `.cursor/rules/**` | `operator:` |

## Beacon

| Codename | Owns | Role |
|---|---|---|
| `beacon` | `LOOP_RADAR.md`, `LOOP_MEMORY.md`, `agents-status/task-briefs/**`, creates approvals | Loop radar. Suggests; never approves; never codes. |

## Coding agents

| Codename | Owns | Role | Branch | Commit |
|---|---|---|---|---|
| `web` | `apps/web/**` | UI | `web/<slug>` | `web:` |
| `api` | `apps/api/**` | Backend/API | `api/<slug>` | `api:` |
| `contracts` | `packages/shared/**` | Shared types — **frozen**, changes need a proposal | `contracts/<slug>` | `contracts:` |

## Ownership matrix

| Path | Owner | Notes |
|---|---|---|
| `apps/web/**` | `web` | UI only |
| `apps/api/**` | `api` | API only |
| `packages/shared/**` | `operator` / `contracts` | Frozen contract; proposal required to change |
| `.cursor/rules/**` | `operator` | Agent rules |
| `agents-status/**` | shared by protocol | Each agent edits only its own journal |

## Cross-boundary rule

`web` needs a field that doesn't exist in `packages/shared`? That's a **proposal**
to change the contract, decided by the Project Lead — not a quick edit. Until
it's decided, `web` and `api` work against the current frozen types (use mocks).
