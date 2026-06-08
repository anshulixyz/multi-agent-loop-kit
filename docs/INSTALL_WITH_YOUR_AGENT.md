# Install the kit with your coding agent

Most people won't copy files by hand — they'll tell their coding agent to set
this up. This page gives you copy-paste prompts to do that safely, for each tool
type. The key principle holds even during install: **the agent proposes, you
approve.** None of these prompts let the agent overwrite your files or guess your
ownership boundaries on its own.

---

## The universal install prompt

Paste this into any capable coding agent (Cursor, Claude Code, Codex, Windsurf,
etc.) **from inside your repo**. Replace the clone URL with wherever the kit
lives.

```txt
You are setting up the Multi-Agent Loop Kit in THIS repo. Follow these steps
exactly and stop for my approval where indicated. Do not overwrite any of my
existing files.

1. Clone the kit somewhere OUTSIDE this repo, e.g.:
   git clone <KIT_REPO_URL> /tmp/loop-kit

2. Run the SAFE installer against this repo (it never overwrites my files; it
   writes a `<name>.loopkit` copy beside any collision, and prints package.json
   scripts instead of replacing mine):
   bash /tmp/loop-kit/scripts/install-into-repo.sh .

3. Report back:
   - the list of files it installed
   - the list of `.loopkit` collision files it created (if any)
   - the package.json scripts it printed (if I already had a package.json)
   STOP here and show me this summary before changing anything else.

4. After I confirm, merge any `.loopkit` files into mine by hand — especially
   AGENTS.md. Never blindly replace mine; combine them.

5. Read my repo's actual structure (top-level dirs, packages, apps), then follow
   `prompts/setup-interview.md`: interview me about build objective, ownership
   split, frozen contracts, and test commands, and DRAFT the resulting
   AGENTS.md ownership map and LOOP_RADAR.md objective as a PROPOSAL. Do not
   finalize them. I decide ownership and direction.

6. Once I approve the ownership map, run:
   bash scripts/bootstrap.sh
   and create one journal + one prompt per agent as described in the README.

Do not start any coding agents or create worktrees until I say so.
```

Why it's shaped this way: the agent does the mechanical work (clone, run the
installer, read your structure) but **stops before** the two things only you
should decide — how your code is partitioned into owned paths, and when agents
actually start. That keeps the human-approval gate intact from the very first
step.

---

## Tool-specific notes

The universal prompt works everywhere. These are small adjustments per tool.

### Cursor

- Open your repo in Cursor, start a new chat in the main workspace, paste the
  universal prompt.
- Cursor reads `.cursor/rules/**` automatically once installed, so after setup
  the ownership and journal rules apply to every Cursor session in that repo.
- For each coding agent later, open its worktree as a separate Cursor window.

### Claude Code

- Run `claude` in your repo root and paste the universal prompt.
- Claude Code picks up a root `AGENTS.md` as project context, so make sure the
  merged `AGENTS.md` (step 4) is the real ownership registry, not the kit's
  generic example.
- Use a separate `claude` session per worktree for parallel agents.

### Codex

- Codex also keys off a root `AGENTS.md`. Same caution as Claude Code: the
  merged `AGENTS.md` must describe YOUR repo's ownership, not the template.
- Paste the universal prompt in a Codex session at the repo root.

### Windsurf / other file-reading agents

- Any agent that can read repo files and run shell commands can follow the
  universal prompt as-is. If it can't run shell, do steps 1–2 yourself, then
  paste from step 3 onward so the agent drafts the ownership map.

---

## If your agent can't run shell commands

Some agents read and edit files but won't execute commands. In that case:

1. You run the installer yourself:
   `bash /path/to/loop-kit/scripts/install-into-repo.sh .`
2. Then paste the universal prompt starting at **step 4**, so the agent helps
   you merge `.loopkit` files and draft the ownership map.

---

## What good setup looks like when the agent is done

- Your `README.md`, `package.json`, `LICENSE`, and CI are untouched.
- `AGENTS.md` describes YOUR paths and agents, not the template's.
- `.cursor/rules/01-ownership.mdc` matches that map.
- `LOOP_RADAR.md` has one concrete build objective for your repo.
- No worktrees or agents have been started without your go-ahead.

If any of those isn't true, the setup isn't done — have the agent fix it before
you start running loops.
