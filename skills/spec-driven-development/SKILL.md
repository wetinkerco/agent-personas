---
name: spec-driven-development
description: >-
  Enforce spec-driven development (SDD). Use before and during any change that looks like a
  feature, refactor, contract change, new dependency, or behavioural change, to confirm a spec
  exists, is the source of truth, and is up to date with the code. Triggers when the user asks to
  "plan", "write a spec", "review", or when a diff spans multiple files, changes a contract, or
  alters behaviour with no referenced spec. Presses on the *why* and refuses to let non-trivial
  work proceed specless. Language- and stack-agnostic; reads `.agents/profile.md` for what counts
  as spec-worthy in this repo.
---

# Spec-Driven Development

The spec is the source of truth; the code is its implementation. If they disagree, one of them is a bug. This skill keeps a written spec ahead of and in sync with the work.

It does **not** replace the repo's house rules, which govern *how* code is written. This governs *whether the change was specified first*.

## When this skill does not apply

**If the profile says `Specs: none`, this repo does not write specs, so stop here.** That is a legitimate choice, not an oversight, and pressing the point is how a useful gate becomes an annoyance that gets disabled. Skip the gate and let the review or the plan proceed.

The one thing that survives: **the *why* is still required.** A change nobody can justify is a problem whether or not the justification would have been written down. Ask the question; do not ask for the document.

## Where specs live

The repo profile (`.agents/profile.md`) names the specs directory; `docs/specs/` is the default. **Match the naming already in that directory** rather than imposing a new scheme. Two conventions that work:

- `spec-<feature>-<year>q<n>.md` when the work is a dated initiative
- `<area>-<topic>.md` for a design doc scoped to one surface

Never rename an existing spec to fit a convention. When in doubt, mirror the closest neighbouring file.

**Pick a kebab-case slug and carry it everywhere.** The spec filename, the branch, and every future review of this work share it. That slug is the only index this system has, and it is how anyone finds the whole history of a change with `ls` and no tooling.

If the repo uses a ticket system, reference the ticket in the spec header. It is how the spec, the change, and the ticket stay findable from each other.

**When a change needs something another team owns**, whether an endpoint, a field, a permission, or a capability, that dependency belongs in the spec explicitly, with its ticket referenced. A spec that assumes something nobody has agreed to build is the most expensive kind of stale.

---

## Is this change spec-worthy?

**The repo profile's "spec-worthy here" list is authoritative.** It is written by people who know what actually goes wrong in this codebase. Use the list below only to fill gaps, or when there is no profile.

**Spec-worthy**, meaning a spec must exist and be current, when the change is any of:

- **A contract change.** An API, schema, wire format, event, or public interface that something outside this module depends on.
- **A data change.** A migration, a new store, a new cache, a change to what is retained or for how long. Anything that can lose or corrupt data.
- **Auth, identity, or permissions.** Sign-in, sessions, tokens, roles, what a user is allowed to do, and what happens when a credential expires mid-operation.
- **A new external dependency.** A service this system does not call yet, a third party, a new runtime or infrastructure component.
- **New user-facing surface.** A screen, page, command, or endpoint that did not exist.
- **A behavioural change to existing logic.** What something shows, when it fires, how an error surfaces, what happens on failure.
- **A refactor or rename touching multiple modules.**
- **Anything irreversible.** A change that cannot be rolled back cleanly once it ships.
- Anything the diff touches across three or more files that hangs together as one idea.

**Not spec-worthy.** Proceed, no spec needed: copy fixes, styling tweaks within an existing design, dependency bumps, a single-file localized bugfix, test-only changes, regenerating generated code, adding a configuration value an existing spec already called for.

When unsure, treat it as spec-worthy and ask. The cost of a missing spec compounds.

---

## Behaviour

### 1. Missing spec on spec-worthy work: stop and ask

Do not silently proceed. Say plainly that this looks like part of a larger feature or refactor and that you need the spec for full context. Then:

- Ask the user to point you to the spec, **or**
- Offer to scaffold one from the template below, confirming the *why* with them first.

Hold the line: a polite refusal to build blind is the correct default. The user can override, but make them do it consciously.

### 2. Spec exists: check it is current

Read the spec, then read the diff. Flag **drift** explicitly, naming the section:

- Code does something the spec does not mention → the spec is stale, or the change is scope creep.
- Spec promises something the code does not deliver → incomplete, or the spec is aspirational.
- **Date** predates the change, or **Status** does not match reality.
- The spec's stated dependencies no longer match what the code actually calls. This is the drift that bites hardest, so check it directly.
- **Part 1 no longer describes what the system actually does.** It is prose, so nothing breaks when it rots, which is exactly why it rots first. If the behaviour changed, Part 1 changes too.
- **Effort** was never revised after the work turned out harder or easier than rated. Not a blocker, but say so, because an estimate nobody corrects teaches the team nothing.

Do not hand-wave "the spec seems out of date." Point at the line.

### 3. Always press on the *why*

Every spec needs a problem statement that survives "why are we doing this?" three times. If the answer is thin ("the competitor has it", "it'd be nice"), push once more for the underlying user problem. A feature without a defensible *why* is a candidate for not being built.

### 4. Require reasonable feedback

This is a two-way contract. If the user pushes back, engage with their reasoning, but ask for a concrete answer, not a hand-wave. "It's fine" is not feedback; "it's fine because X is out of scope and tracked in TICKET-1451" is. If they decline a spec for genuinely trivial work, accept it and move on.

---

## Spec structure

Every spec is **frontmatter + two parts**:

1. **Part 1, for everyone.** Plain language, no jargon. What is changing, for whom, and why it matters. Written so someone in support, sales, or leadership can read it and explain the change back correctly.
2. **Part 2, for engineers.** Scope, requirements, design, rollout, tasks, open questions.

The split is not cosmetic. Part 1 is where the *why* has to survive contact with someone who does not know the codebase; if you cannot write it without jargon, you do not understand the change well enough to design it yet.

### Frontmatter

```markdown
**Date**: 2026-08-09
**Status**: Draft
**Area**: Inbox (conversation list, composer)
**Effort**: 3 / 5 overall, driven by offline drafts. Per piece: conversation list **2** (a
standard list over an existing endpoint), composer **2**, offline drafts **4** (new local store,
conflict resolution, no precedent here).
**Owner**: <name>
**Ticket**: TICKET-####
```

- **Date.** When the spec was **last updated**, not when it was created. Bump it on every revision; a stale Date is the cheapest drift signal there is.
- **Status.** `Draft` · `In progress` · `Shipped` · `Blocked` · `Abandoned`. Keep it true.
- **Area.** The product surface in reader-friendly terms, with the specific pieces in parentheses. Not file paths.
- **Effort.** See below.
- **Owner** and **Ticket.** Add when they exist.

### Effort: 1 to 5, complexity, not time

Effort rates **how hard this is to get right**, not how long it takes. A two-week slog of mechanical work is a 1. A three-day change to how sessions refresh is a 4. Do not convert to days, and do not inflate for volume.

| Rating | Meaning |
|---|---|
| **1** | Known and contained. A copy change, a static page, a config value. No design decisions, no unknowns. |
| **2** | Routine. A standard pattern applied where it has been applied before, following the shape of a neighbour. |
| **3** | Substantial. Several moving parts, or an unfamiliar area, or a couple of open design choices, but the approach is clear once decided. |
| **4** | Hard. A pattern new to this codebase, auth or identity work, sync or consistency behaviour, a new infrastructure component, or unknowns that must be resolved before the design is safe. |
| **5** | Very hard or high-blast-radius. Novel architecture, a change that cannot be rolled back, several unresolved unknowns, or something nobody here has done before. |
| **blocked** | Not a number. Gated on something outside this spec. Name the blocker and do not estimate. |

Rules:

- **The overall number is not a sum or an average.** It is the complexity of the whole thing, usually set by its hardest part. Say what drives it.
- **Break it down when the work spans several surfaces**, using the same 1–5 scale per item with a few words on why. That breakdown is what makes the number arguable, and an arguable number is the point.
- **A 5 is a signal to split the spec**, not a badge. If the overall is a 5, say explicitly whether it can be staged.
- Effort is a **claim you can be wrong about.** Revise it when you learn more, and bump the Date.

### Template

```markdown
# <Feature name>

**Date**: YYYY-MM-DD
**Status**: Draft
**Area**: <product surface> (<specific pieces>)
**Effort**: <n> / 5 overall, <what drives it>. Per <surface/phase>: <X> **<n>** (<why>), <Y>
**<n>** (<why>).
**Owner**: <name>
**Ticket**: TICKET-####

---

## Part 1: What's changing and why

*Plain language. No jargon. A colleague outside engineering should be able to read this and
explain the change back correctly.*

### In short
Two or three sentences: what will be different once this ships, described from the outside. Lead
with the change someone notices, not the mechanism behind it.

### The problem today
What hurts right now, told the way the person living with it would tell it. Be specific about the
moment it goes wrong. This is the part that must survive "why?" three times.

### Who this affects
Which users, roles, or teams, and roughly how many or how often.

### What this won't do
The limits, in plain terms. Name the obvious adjacent thing people will assume is included and say
whether it is.

---

## Part 2: How we'll build it

### Goals / Non-goals
- Goal: ...
- Non-goal: ... (explicitly out of scope)

### Requirements
Testable acceptance criteria: statements of done someone can actually check.

### Design
Key decisions and the trade-offs considered **and rejected**. Be concrete about whichever of these
apply:
- **Surface.** The new modules, routes, screens, endpoints, or jobs, and where they sit.
- **Dependencies.** The exact services, endpoints, tables, or permissions; whether they exist
  today; the ticket and the owner if they do not.
- **Data and state.** What is stored, where, for how long, who owns it, and what is derived
  rather than persisted.
- **Failure paths.** No connection, a slow one, an expired credential, a denied permission, a
  partial write, a process that dies halfway.
- **Security.** The trust boundaries crossed and the control at each one.
- **Compatibility and rollout.** What an old client or a half-migrated database does, whether
  this ships incrementally, and how it rolls back.
- **Risks.**

### Tasks
Ordered implementation steps (link changes as they land).

### Open questions
Unresolved decisions blocking or shaping the work, including every unconfirmed dependency.
```

### Writing Part 1

The whole point is that it survives an audience with no context. So:

- **No jargon, and no undefined internal nouns.** If a term is genuinely unavoidable, define it in the same sentence and move on.
- **Describe the outcome, not the mechanism.** "Messages you write with no connection send themselves once you're back online", not "we persist drafts locally and flush on a connectivity listener."
- **Be concrete.** Name the person and the moment. Vague benefit language ("improves engagement", "better experience") is how a weak *why* hides.
- **No marketing voice.** Internal document, not a launch post. Skip "seamlessly", "robust", "empowers", "unlocks".
- **Short paragraphs beat bullet soup.** Part 1 is prose; the lists live in Part 2.
- **Be honest about the downside.** If it makes something else slower, larger, or temporarily worse, say so here, not buried in Part 2 risks.
- **Keep it under a page.** If Part 1 is long, the change is several changes.

The check: **could you paste Part 1 into a message to a customer-facing colleague and have them correctly explain what is changing?** If not, rewrite it. And a reader must never need Part 2 to understand Part 1.

Keep the whole thing short and honest. A one-page spec that is true beats a ten-page one that is stale. Match ceremony to scope, and for a genuinely small change Part 1 may be three sentences. Update the spec in the **same change** as the code it describes; that is the only way "up to date" stays true.

---

## Guardrails

- Do not gold-plate: trivial changes do not need a spec, and a small spec does not need every section filled.
- The house rules win on code-style conflicts; this skill gates *context and intent*, not taste.
- Do not block a sound change purely because the spec's prose is imperfect. Flag it and let the work proceed.

## Downstream

This gate is the **first step** of a code review: the reviewer persona runs it before grading any diff, and reviews are persisted alongside the spec under the same slug. A stale spec surfaced here becomes the review's headline finding. The planner persona is the one who writes the spec in the first place.
