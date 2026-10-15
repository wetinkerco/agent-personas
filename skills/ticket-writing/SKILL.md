---
name: ticket-writing
description: >-
  Write a product ticket — one task with a clear, defined outcome, in plain language, with no
  implementation detail. Follows Linear's method: issues, not user stories. Use whenever work is
  being defined: a feature, a fix, a change to an existing surface. Triggers on "write a ticket",
  "define this", "what are we actually building", "scope this", or before any spec is written. A
  ticket comes first and a spec comes second; most work needs only the ticket. Minimal by default
  — often a title and nothing else. Asks whether to break down into sub-tickets by work and type of
  work in the same file. Reads `.agents/profile.md` for where tickets live and how they are named.
---

# Ticket Writing

This follows [Linear's method](https://linear.app/method/write-issues-not-user-stories): write issues, not user stories. No "As a user, I want…", no ceremony. Describe the task in plain language and move on.

Their argument, and it holds: user stories are "a cargo cult ritual that feels good but wastes a lot of resources and time." They obscure the work to be done, take longer to write and read than the work deserves, and push engineers into coding to the requirements instead of thinking about the experience. Nobody talks that way about software in a real conversation.

We say *ticket* where Linear says *issue*. Same artifact.

## What a ticket is

**One task with a clear, defined outcome** — a piece of code, a design, a document, an action someone takes. If it isn't a task, it doesn't belong in the tracker. "Investigate why signups dropped" is a question, not a ticket. "Look into pricing" isn't one either.

Two outcomes means two tickets. Splitting is the default, not a last resort.

When a ticket spans multiple streams or disciplines, ask if it should be broken down into sub-tickets by work and type of work (e.g. backend, frontend, devops, design), kept in the same ticket markdown file.

If an open question blocks the work, the ticket isn't ready. Resolve it, then file.

## Title

The title does the work. State what the task is, plainly and briefly, so someone scanning the backlog knows what this is without opening it.

> `Indicate to users when todo edits are auto-saved`

Not "Save state improvements", not "Fix the todo list". No bracketed area prefix — the tracker already carries the project and the labels.

**A title is a task, not a topic.** `Todo lists: Private by default` names the subject and leaves the reader to work out what's being done to it. `Make todo lists private to the person who created them` is the task. Start with a verb and the ambiguity has nowhere to hide.

Most tickets are finished here.

## Description

Optional, and short. Write what someone needs in order to do the work, then stop.

**The change comes first, with no heading above it.** A few standalone lines saying what will be true when this ships. One idea per line, and no line that only sets up the next one. For literal UI copy or layout, a code block beats a paragraph describing one.

**Two headings in the main body, at most, and only when they apply.** `Not in scope` and `Open question(s)`, in that order, each a numbered list (followed by `## Sub-tickets` when broken down by stream). Nothing else gets a heading — no problem statement, no "who this affects", no "solution", no "what should happen".

**Effort is the last line** (for standalone tickets), after everything else. One line, no heading. When a ticket has sub-tickets, omit Effort from the parent ticket entirely — only the sub-tickets carry estimates. See below for the scale.

The whole shape:

> # Make todo lists private to the person who created them
>
> You see your own lists and nobody else's. Private by default, and for now the only setting.
>
> Each list gets a "Private to you" pill.
>
> The list index loses the date grouping — one flat list, most recently updated first.
>
> ## Not in scope
>
> 1. No sharing. No way to send a list to someone else, no workspace-wide view. If sharing arrives later it's an explicit action by the owner, never a default.
> 2. No per-role visibility rules — that's a separate piece of work. We'll map what an admin, a manager, and a member each need.
>
> ## Open question(s)
>
> 1. Can an admin ever read someone's lists — for compliance, or when an employee leaves?
>
> **Effort: 3** — the permission model is one live decision, the rest is contained.

The heading in that example is there to show you the title; it is not part of the body. Every tracker has a title field, so put it there and start the body at the first line of the change.

`Not in scope` is where a split gets recorded. When work comes out of a ticket, it goes here as one line, so nobody assumes it ships with the rest.

**State decisions, not rationale.** The why belonged in the conversation where the decision got made. In the ticket it's padding, and the padding almost always takes the same shape: an invented person having an invented feeling.

> **Rationale clause:** People tracking work they haven't committed to yet don't know whether their manager reads it, so they keep those todos somewhere else.
>
> **Decision:** You see your own lists and nobody else's.

Tells: a hypothetical user doing a hypothetical thing, a list of examples where none is needed, any clause answering "why does this matter?", and any paragraph that arrives before the actual change does.

Write the problem only when the change doesn't imply it — a bug report needs the broken behaviour, one plain sentence of it. A decision that's already been made doesn't need to be argued for.

**Link, don't summarize.** The conversation, the design, the related ticket — paste the URL. A link stays accurate and costs a line; a summary goes stale and costs a paragraph. When you're carrying customer feedback, quote it directly rather than paraphrasing it.

**One departure from Linear.** Their descriptions can be thin because the team talks the experience through together first, so the shared understanding already exists in the room. Your readers weren't in that room, and agents have no room at all. That buys a line or two — the open question, the thing explicitly out of scope, the design link. It does not buy a problem statement, a "who this affects", or a heading for each.

## Sub-tickets by type of work

When work touches multiple disciplines or work streams, **always ask the user if they want to break down the ticket into sub-tickets by work and type of work**. Do not decide to split silently, and do not assume a single monolithic ticket without asking.

Common breakdowns are engineering-focused:
- **Backend** (APIs, schemas, services, migrations)
- **Frontend** (UI components, styling, client state, interactions)
- **DevOps / Infra** (CI/CD pipelines, containerization, provisioning, deployment configuration)

This structure is domain-agnostic. Apply it equally to non-engineering streams when relevant: **Design** (wireframes, tokens), **Copy / Content**, **Analytics / Tracking**, **Legal / Compliance**, or **Operations**.

### Same ticket markdown file

**Sub-tickets must be written in the same ticket `.md` file**, directly beneath the main ticket. Never split them into separate files. Keeping them together preserves the whole initiative in one place without scattering context across multiple artifacts.

### Structure of a sub-ticket

**Parent tickets carry no estimate.** The parent ticket defines the overarching initiative and omits the `Effort` line. Each individual sub-ticket carries its own estimate, avoiding double-counting in trackers that roll up points.

Each sub-ticket lives under a `## Sub-tickets` heading. It follows the exact same rules as the top-level ticket:
- An `###` heading stating the stream and the task starting with a verb (e.g. `### Backend: Scope list queries to the active user`).
- Standalone lines stating what will be true when that stream's work ships.
- Its own `Not in scope` or `Open question(s)` only if specific to that stream.
- An individual `Effort` line for that piece.
- Still no implementation details — describe what that stream delivers, not the lines of code.

### The whole shape with sub-tickets

> # Make todo lists private to the person who created them
>
> You see your own lists and nobody else's. Private by default, and for now the only setting.
>
> Each list gets a "Private to you" pill.
>
> The list index loses the date grouping — one flat list, most recently updated first.
>
> ## Not in scope
>
> 1. No sharing. No way to send a list to someone else, no workspace-wide view.
>
> ## Sub-tickets
>
> ### Backend: Scope list queries to the active user
>
> Lists endpoint returns only records owned by the authenticated caller.
>
> Attempting to fetch another user's list by ID returns a 404.
>
> **Effort: 2** — straightforward filter on existing user foreign key.
>
> ### Frontend: Display private-to-you badge on lists
>
> Each list header displays a "Private to you" badge.
>
> Empty state shows copy explaining lists are visible only to the creator.
>
> **Effort: 1** — UI-only change to existing badge component.
>
> ### DevOps: Verify migration runs with zero downtime
>
> Ownership backfill migration runs without table lock on active database.
>
> Rollback plan verified in staging prior to production deploy.
>
> **Effort: 2** — requires testing concurrent writes against staging replica.

## Not the spec

No implementation, no architecture, no step-by-step technical task breakdown. The moment you write "add a webhook" or "a new column on the todos table", you've left the ticket. Breaking down into sub-tickets by type of work separates outcomes across disciplines; it does not list implementation procedures.

That material, and the research behind it, belongs in the spec — when there is one. Most work doesn't need one. See `spec-driven-development` for the gate, and run it after the ticket exists, never before.

## Where tickets live

**The tracker is the system of record, not this repo.** It owns the identifier, state, labels, assignee, and dates.

**Everything above this section is the same on every tracker.** A ticket is a title and, sometimes, a short body; GitHub Issues, Linear, Jira, Shortcut, and a text file on a shared drive all take those two things. The tracker changes how you file it and where a few fields land, and nothing else. Write the ticket first, then file it.

The repo profile (`.agents/profile.md`) names the tracker and the ticket prefix. If it names none, ask which tracker this repo uses rather than picking one, and **never file into a tracker you inferred** — a ticket in the wrong system is worse than no ticket, because nobody goes looking for it.

You write the title and body. You do not write the metadata — **never invent a ticket identifier**, and don't add frontmatter to a ticket.

File through whatever the tracker gives you, preferring its CLI or API over a browser step someone has to do by hand:

| Tracker | File with | Identifier | Effort |
|---|---|---|---|
| GitHub Issues | `gh issue create`, `gh issue edit` | assigned number, `#412` | last line of the body |
| Linear | its CLI or MCP server, else its API | team prefix, `ENG-412` | the estimate field |
| Jira | its CLI or MCP server, else its REST API | project key, `PROJ-412` | the story-point field, if the project uses one |
| Anything else | its own tooling | whatever it assigns | its estimate field, else the last line of the body |

**Never write the ticket to a file in the repo** unless the profile says the tracker *is* a directory in this repo. A ticket committed alongside the code is a second system of record that immediately starts drifting from the first.

Once a ticket exists, reference it by identifier from the spec, the branch, and the review, so the whole history of a change is findable from any one of them.

## Effort — 1 to 5, complexity, not time

Effort rates how hard this is to get *right*, not how long it takes. Two weeks of mechanical work is a 1. Three days rethinking how pricing is derived is a 4.

| Rating | Meaning |
|---|---|
| **1** | Known and contained. No open decisions. |
| **2** | Routine. A pattern applied where it's been applied before. |
| **3** | Substantial. Several moving parts, or a couple of live design choices. |
| **4** | Hard. New ground, or touching money, trust, or customer data. |
| **5** | Very hard or hard to reverse. Novel or high blast radius. |
| **blocked** | Not a number. Name the blocker, don't estimate. |

This is the same scale `spec-driven-development` uses, deliberately: the ticket's rating is the first draft of the spec's, and a spec that lands far from its ticket is worth a sentence explaining what was learned.

The number isn't a sum or an average — it's set by the hardest part, and you say what drives it. Break it down per piece when the work spans several. A 5 is a signal to split, not a badge.

**Parent tickets carry no estimate.** When a ticket is broken down into sub-tickets, omit the Effort rating on the parent ticket. Only the sub-tickets carry individual estimates, preventing double-counting in trackers that calculate rollups or velocity totals.

**Where it goes:** the tracker's own estimate field when it has one, mapped onto whatever that field is called — Linear's estimate, Jira's story points. When the tracker has no such field, GitHub Issues being the common case, it's the last line of the body:

> **Effort: 4** — touches how money is derived, and the rounding rule is undecided.

The clause after the dash names what sets the number. Without it the digit is unfalsifiable. `blocked` replaces the digit entirely — name the blocker, don't estimate around it.

## Voice

Authoritative and short. The thinking is already done — present the conclusion, in as few words as that takes.

**Active voice.** "The label shows nothing until the first edit", not "nothing is shown".

**No hedge words.** Cut *lean*, *probably*, *likely*, *worth considering*, *might want to*, *my instinct is*, *arguably*, *seems like* on sight. If you're unsure enough to hedge, it's an open question — resolve it, don't soften the sentence.

**No storytelling.** It's a good instinct in a conversation and the wrong one in a ticket. Say what should be true, and stop. The person reading this is about to build it, not be persuaded of it.

**Cut the padding.** "In order to" is "to". "Currently the user is unable to" is "the user can't". Delete any word that doesn't change the meaning, and any sentence that only announces what the next one says.

**No jargon, no undefined internal nouns, no marketing voice, no checkboxes.**

**For anything a customer will read, the repo's tone guide governs instead**, when the profile names one. Ticket voice is for the team; product copy has its own reader and its own rules.

## Guardrails

- **The house rules named in `.agents/profile.md` win on any conflict**, including the tracker's own template if this repo has one.
- **Always ask before creating sub-tickets.** When work touches multiple areas, ask if the user wants sub-tickets broken down by work and type of work (backend, frontend, devops, design, etc.).
- **Sub-tickets stay in the same ticket `.md` file.** Never scatter sub-tickets across multiple files.
- **Parent tickets never carry an estimate.** When sub-tickets exist, estimate only the sub-tickets to avoid double-counting.
- Do not gold-plate. Most tickets are a title. A description that exists only to look thorough is worse than no description.
- Do not file a ticket to record a question, a reminder, or a note to yourself. If it has no defined outcome, it isn't a ticket.
- Never invent a ticket identifier, a status, or an assignee. The tracker owns them.
