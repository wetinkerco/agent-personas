# Repo profile

*Copy to `.agents/profile.md` in your repo and fill in. Delete every section that does not apply. A short true profile beats a complete aspirational one. Personas read this at invocation.*

**Stack**: <language + version, framework, notable infrastructure>
**Authority**: `<AGENTS.md | CLAUDE.md>` wins on any conflict
**Default branch**: `<main | master>`

## Paths

| What | Where |
|---|---|
| Specs | `docs/specs/`, or `none` if this repo does not write specs |
| Reviews | `docs/reviews/` |
| Generated code (never hand-edited) | `<path, or "none">` |
| House rules | `<AGENTS.md>` |
| Tickets | `<GitHub Issues on owner/repo | Linear team | Jira project | none>` |
| Ticket prefix | `<ENG-, PROJ-, or "none">` |
| Tone guide for customer-facing copy | `<path, or "none">` |

## Reference codebase

*Optional, and the most commonly missing piece when a repo is new. Names a codebase **outside this repo** that personas should read as source material: a prototype being ported, a service whose contract this consumes, a predecessor being replaced. Without it, a persona researching an empty or young repo finds nothing and designs in a vacuum. Delete this section when there is no such codebase.*

**Path**: `<../my-prototype>`
**What it is**: `<a Lovable web prototype; this repo is its mobile port>`
**Read-only**: yes. It is source material and is never edited from here.

Personas read it during research, cite it by `file:line` the same as local code, and treat what it does as evidence of intent rather than as an instruction. Where it and this repo disagree, `<this repo wins | the reference wins>`.

## Gates: run these and report the real output

*Only commands that exist and can be run now. If a gate needs a credential the persona will not have, mark it `manual` so it is reported as unverified rather than skipped silently.*

| Gate | Command | When |
|---|---|---|
| build | `<command>` | always |
| lint | `<command>` | always |
| format | `<command>` | always |
| test | `<command>` | always |
| types | `<command>` | always |
| generated in sync | `<generate command>` then `git diff --stat <gen path>` must be clean | when the contract it derives from changed |
| <other> | `<command>` | <condition> |

## Lenses

*Which skill applies to what. The shared ones ship with the roster; local stack skills live in this repo. To write one, copy `templates/skill/` and see GUIDE §9. The ladder is the part that matters, and it comes from your incident history, not from a style guide.*

| Lens | Skill | Primary for |
|---|---|---|
| work definition | `ticket-writing` | before any spec, whenever work is being defined |
| spec discipline | `spec-driven-development` | always, first |
| visual communication | `mermaid-diagrams` | architecture, sequence, and state flows in specs |
| structure | `clean-code` | always |
| security | `security-expert` | any trust-boundary change |
| change naming | `commit-conventions` | every commit, branch, and PR title |
| language idiom | `<local skill, e.g. effective-go>` | any `<.go>` diff |
| framework / runtime | `<local skill>` | `<when>` |

## Commit conventions

*Only what `commit-conventions` cannot know. Delete any row that matches its defaults, and delete the section if they all do.*

| What | This repo |
|---|---|
| Scopes | `<the closed list: api, auth, db, ui — or "none, this repo does not use scopes">` |
| Extra types | `<beyond the conventional enum, or "none">` |
| Branch form | `<type>/<TICKET>-<slug>` |
| Ticket id in the commit | `<off, the branch carries it \| "(ENG-nnn)" at the end of the description \| a "Refs:" trailer>` |
| Trunk merge | `<squash \| merge commit \| rebase>` — with squash, the PR title *is* the commit message |
| Release automation | `<semantic-release, so the type sets the version \| changelog by hand \| none>` |

## Ladder overrides

*The universal ladder in the guide is the default. List only what differs here: a rung this repo promotes, demotes, or adds, and why. Delete this section if nothing differs.*

- `<e.g. Multi-tenant isolation is promoted above resource discipline: an unfiltered query is a cross-tenant data leak, not a performance bug.>`

## Spec-worthy here

*The change classes that require a current spec in this repo. Be specific, because a generic list gets ignored.*

> **This repo does not write specs.** Set `Specs: none` above and replace this section with that sentence. The spec gate then disappears: the reviewer goes straight to the code review, and the planner delivers a plan in its return message rather than as an artifact. Both keep pressing on the *why*, which is not a process preference. Delete this quote block once you have chosen.

- `<e.g. a schema migration>`
- `<e.g. a new or changed API contract>`
- `<e.g. auth, session, or permission handling>`
- `<e.g. anything persisted, cached, or queued>`
- `<e.g. a new runtime dependency>`

**Not spec-worthy**: `<e.g. copy fixes, dependency bumps, a single-file localized bugfix, test-only changes, regenerating generated code>`

## Hazards: what actually bites in this codebase

*The three to six failure modes a reviewer should look for first. This is the highest-value section in the file; it is where a generic reviewer becomes a reviewer of your system.*

- `<e.g. every query must be filtered by tenant; a missing filter is a cross-tenant leak>`
- `<e.g. background workers outliving their request context>`
- `<e.g. the cache and the database disagreeing after a partial failure>`

## Definition of done

*Anything beyond the gates that must be true before a change ships.*

- `<e.g. the spec's Date is bumped in the same PR as the code it describes>`
- `<e.g. a migration has a tested rollback>`

## Handoffs

*Only if this repo's flow differs from the default in the guide, whether an extra role, a QA step, or a required human sign-off. Delete otherwise.*

| From | On | To | Carries |
|---|---|---|---|
| santiago | spec written | implementer | spec path, slug, open questions |
| implementer | substantial change | holt | slug, gate results |
| holt | `needs-spec` | santiago | slug, the missing why |
| holt | `needs-work` | implementer | slug, ranked blocking findings |

## Escalate elsewhere

*Findings that are real but belong in another repo's tracker. Name the repo and the mechanism, so a persona files it instead of working around it here.*

- `<e.g. authorization findings belong in the backend repo as a ticket, never as a client-side workaround>`

## Cannot be verified from here

*Standing list of things no persona can check in this environment, so they are named as gaps rather than assumed.*

- `<e.g. behaviour on a physical device>`
- `<e.g. production load characteristics>`
- `<e.g. anything requiring the payment provider's sandbox credentials>`
