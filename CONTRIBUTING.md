# Contributing

Thanks for improving Multi-Agent Loop Kit.

This project is intentionally markdown-first and practical. The goal is not to claim full autonomy. The goal is to make human-supervised parallel AI coding work safer and easier to coordinate.

## Good contributions

- clearer onboarding docs
- examples for different repo shapes
- better prompts and templates
- safer shell scripts
- path ownership checks
- GitHub Actions for PR validation
- GitHub Issues / Projects / Linear / Notion integration examples
- Cursor / Claude Code / Codex / Windsurf usage notes
- real-world pressure tests

## Please avoid

- marketing the kit as a fully autonomous software factory
- removing human approval gates without replacing them with a clear safety model
- making scripts destructive by default
- assuming every repo uses Bun, TypeScript, or a monorepo

## Reporting issues

If the kit does not work for your repo, please open an issue with:

- repo shape
- number of agents
- AI coding tool used
- OS and shell
- whether you used worktrees, clones, containers, VMs, or hosted workspaces
- command run
- expected result
- actual result
- relevant logs/screenshots

## Pull requests

Use the PR template. Keep changes small and explain the coordination impact.

### Commit message prefixes

CI checks that every commit subject starts with a prefix. You don't need to
invent an agent codename for ordinary contributions — use a generic prefix:

```txt
docs: fix README typo
chore: update dependency
ci: tweak PR validation
example: add a new repo-shape example
fix: correct spawn-agent base branch detection
```

Agent codenames (`frontend:`, `backend:`, `beacon:`, ...) are for work done
inside a configured multi-agent repo. Both styles pass CI. Branch names follow
`<prefix>/<slug>` (e.g. `docs/fix-readme` or `frontend/demo-intent-capture`).
