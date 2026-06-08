# Changelog

## v0.5.0 — first public release

A file-based operating model for running parallel AI coding agents in a
continuous, human-approved loop.

- **Protocol** — path ownership, git worktrees, file-based coordination, frozen
  contracts, and the authority split (Beacon suggests, agents build, you approve).
- **Operating guide + runbook** — how to break work into agents, write each
  agent's prompt, run the loop, and what to do when things deviate.
- **Status board** (`bun run status`) — every agent's state at a glance.
- **Agent-driven setup** — point your agent at `prompts/setup-interview.md`; it
  interviews you and configures the kit for your repo.
- **Safe installer** for existing repos (never overwrites your files) and a
  GitHub-template path for new repos.
- **Three modes** — Setup mode (agent configures the repo), Loop mode (Beacon
  proposes, you approve, agents build), and Safe auto-mode (approved agents work
  owned slices until a stop condition). See `docs/AUTO_MODE.md`. Not unattended
  autonomy.
- **Two worked examples** — a generic web + api + shared-types repo, and a richer
  5-agent product with a full worked loop iteration.

Releases are tracked on the GitHub Releases page from here on.
