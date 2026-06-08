# Preparing your spec (is the project ready to loop?)

This kit coordinates *execution*. It assumes you already know what you're
building. Multi-agent loops amplify whatever you feed them — a sharp spec turns
into fast parallel progress; a fuzzy one turns into N agents inventing N
different things that you then have to reconcile.

So before you spawn agents, get the project to "ready." Here's what that means.

---

## The readiness checklist

You're ready to loop when you can hand an agent these, and it would know exactly
what to build without asking you what the product is:

- [ ] **A project plan** — what you're building, and the slices that get you
      there. Enough that work can be split into independent chunks.
- [ ] **Clearly defined goals** — one concrete objective the loop optimizes
      toward (this becomes your `LOOP_RADAR.md` objective).
- [ ] **A tech spec** with, at minimum:
  - [ ] **Data models / contracts** — the shared types every agent depends on.
        These are the thing you freeze first. (In the examples, this is
        `packages/iaip-types` / `packages/shared`.)
  - [ ] **APIs / module boundaries** — the routes, interfaces, and surfaces each
        agent owns and how they talk to each other.
  - [ ] **Per-area detail** — enough that each agent's slice is concrete
        ("build endpoint X returning shape Y"), not a vibe ("make the backend").
  - [ ] **The end-to-end flow** — the one path that has to work, so agents know
        what their piece enables.
- [ ] **If there's a frontend: UI specs + a design system** — screens,
      components, and design tokens. Without these, each frontend agent invents
      its own look and you spend the loop reconciling styles.
- [ ] **Test commands** — how a slice proves it's safe (`bun test`, `pytest`, …).

If you can't tick most of these, the project isn't ready for a multi-agent loop
yet. Start with **one** agent (or just yourself) until the boundaries are clear,
and use this kit's docs as planning templates rather than running the full loop.

---

## How agents consume the spec

Each agent's prompt points at the spec sections relevant to its owned paths — it
reads those *before* writing code. For example, a backend agent's prompt might
say: "read spec sections 4 (data models), 5 (APIs), 7 (your module)." That's how
the spec stays the single source of truth for *what*, while `AGENTS.md` is the
source of truth for *who owns what*. Put the spec in the repo (e.g. `SPEC.md` or
`docs/spec/`) so agents can read it at session start.

---

## Don't have a spec yet?

Writing a good plan + tech spec + design system is its own craft, and there are
strong prompting workflows for producing them with an AI before you ever start
the build. That's upstream of this kit — but it's the difference between a loop
that flies and one that thrashes.

> **This section is a stub.** A companion guide on *generating* a
> production-ready spec, tech plan, and design system (the prompting workflow
> that feeds this kit) is planned. If you have a workflow that works, that's
> exactly what belongs here — contributions welcome.
