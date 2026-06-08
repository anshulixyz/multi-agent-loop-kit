# Naming Strategy

This kit intentionally separates **the reusable framework** from **repo-specific agent names**.

## Why the core kit uses generic names

The public template uses neutral example codenames such as `frontend`, `backend`, `agentkit`, and `ops` so that any repo can adopt the system without feeling tied to Intent Pad.

That is intentional for portability.

## Why the original names still matter

The original Intent Pad names are stronger and more memorable:

- `Project Lead` — contracts, specs, rules, final approval
- `Anvil` — Pad / app surface
- `Conduit` — Bus, protocol, mocks, client
- `Forager` — grocery agents and agent kit
- `Reel` — media agents
- `Watchtower` — cockpit / dashboard
- `Beacon` — loop radar and task intelligence

These names make the system feel like a real operating model, not a generic project-management template.

## Recommended GitHub structure

Use both layers:

```txt
/AGENTS.md                         # generic portable template
/examples/intent-pad/AGENTS.md      # named-agent preset
/examples/intent-pad/LOOP_RADAR.md  # demo-style loop radar
/docs/NAMING_STRATEGY.md            # explains this choice
```

## Recommendation

For the public repo:

1. Keep the root files generic.
2. Include the original named setup as the canonical example.
3. Use `Beacon` as the default loop-agent name in both generic and example flows.

This makes the project reusable while preserving the originality of your system.
