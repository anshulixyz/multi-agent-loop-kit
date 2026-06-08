# Example: web + api + shared-types

The simplest honest shape for the loop: a typical app split into three owned
surfaces, run by three agents. Use this as your starting template when adapting
the kit to a normal product repo.

```txt
Project Lead = you — approvals, direction, frozen contracts
Beacon       = loop radar (non-coding)
web          = owns apps/web/**           (the UI)
api          = owns apps/api/**           (the backend)
contracts    = owns packages/shared/**    (types shared by web + api) — FROZEN, Project-Lead-gated
```

The interesting boundary is `packages/shared/**`: both `web` and `api` depend on
it, so it's a frozen contract. Neither agent may change it directly — a change
there is a **proposal**, not a task brief. That single rule is what keeps the two
agents from breaking each other.

Read in order: `AGENTS.md` (who owns what) → `LOOP_RADAR.md` (what's next) →
`prompts/` (each agent's identity) → `agents-status/` (where they report state).
