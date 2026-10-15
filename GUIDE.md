# The guide

How these personas are built, why they're shaped this way, and how to write your own. Nothing here is specific to a language, a framework, or a coding agent.

Today, we cover:

1. **What this is, and what it isn't.** Why there's no orchestrator, and why that's the point rather than a gap.
2. **The authority chain.** Four layers, and the rule that decides conflicts between them.
3. **Anatomy of a persona.** The six parts, and which one does the most work.
4. **Why a character.** What a name buys you that a list of adjectives doesn't.
5. **The bookend pattern.** Three roles, three write scopes, and the constraint that makes them safe.
6. **The handoff contract.** How work moves between personas without a dispatcher, and how the review loop terminates.
7. **Ranked ladders.** Why every reviewing document needs one, and how to build one that produces findings.
8. **Verify, don't assume.** The highest-value behaviour in the set.
9. **Anatomy of a skill.** Three tiers, two modes, and how to author your own.
10. **The profile.** The one file each consuming repo writes.
11. **Harness mapping.** Where the files go for each tool, and what to do when a tool has no subagent concept.
12. **Anti-patterns.** The eight ways this drifts, learned by watching it drift.
13. **Adding a persona.** The bar, and why most candidates don't clear it.

---

# 1. What this is, and what it isn't

This is a role and contract system with artifact-mediated handoff: personas are documents, handoffs are files on disk correlated by a shared slug, and there is no dispatcher, no state schema, and no runner.

**That absence is deliberate.** Encode execution and the system binds to one harness's orchestration primitives, at which point it stops being portable. Prose personas and files on disk run everywhere, including in front of a human with no agent at all.

The topology is trivial: three nodes in a line. All the value sits in the quality of the prose at each node, so that's what to optimize. Not the graph.

---

# 2. The authority chain

Every persona and every skill defers upward. State the chain explicitly in each document, because a model left to itself will resolve conflicts by recency, which means whichever instruction it read last.

```
house rules  (AGENTS.md / CLAUDE.md)      ← wins over everything
   ↑
repo profile (.agents/profile.md)          ← gates, lenses, paths, hazards
   ↑
persona      (personas/*.md)               ← role, workflow, output contract
   ↑
skill        (skills/*/SKILL.md)           ← the rubric for one dimension
```

**More specific and more local wins.** A skill says extract this into a function, the house rules say inline it because we prefer fewer files, so you inline it. When two skills overlap, prefer the more specific one: a language-idiom skill outranks a general structure skill on a question of language idiom, and loses to it on a question of layering.

Two rules keep this from turning to mush.

**Security correctness never yields to style.** It can yield on *how* the fix gets written, since the fix should read like the surrounding code, but not on whether the fix happens.

**A house rule that's wrong is still a house rule.** Personas follow it and say plainly that they disagree. They don't quietly route around it, because a persona that decides which rules to honour is a persona nobody can predict.

---

# 3. Anatomy of a persona

Six parts, in this order. Skip none of them.

## Frontmatter

```yaml
---
name: holt                    # the invocation handle, short and memorable
description: >-               # when to dispatch this persona, and worked examples
  ...
model: inherit
color: red
---
```

**The `description` does more work than anything else in the file**, because it's what a dispatcher or a human skimming a list reads to decide whether this is the right persona. Write it as: what the persona is for, what it channels, then two or three worked examples in this form.

```
- <example>
  Context: <the situation>
  user: "<what they actually typed>"
  assistant: "<the dispatch, in one sentence>"
  <commentary>why this persona and what it will do first</commentary>
  </example>
```

Those examples aren't padding. A description without them dispatches unreliably, since "review my changes" and "clean this up" are close enough in the abstract that only concrete cases separate them.

Name the file for the role (`reviewer.md`) and set the frontmatter `name` to the character (`holt`). The file stays self-describing in a directory listing while the handle stays short to type.

## Identity

One paragraph covering who this persona is, and the *professionalized* version of the character's traits. "Exacting standards, procedural rigor, precision about language, and complete immunity to enthusiasm as a substitute for evidence" is usable. "Says hot damn" is not.

**Put the counterweight in the same paragraph.** Holt is exacting *and* a mentor who doesn't nitpick. Without it, a persona built on a strong trait runs straight to its own caricature.

## Voice

One paragraph on register, plus one hard limit. The limit is always a form of *substance over bit*: a joke is allowed, it never replaces the explanation, and the persona never trades a useful sentence for a flourish.

## Lenses

Which skills this persona uses, when each applies, and where they live. Generic personas name the categories and read the specifics from the profile:

> Your lenses come from `.agents/profile.md`. The universal ones, structure and security and spec-discipline, always apply. The language and framework lenses are whatever the profile names.

## Workflow

Numbered steps in the order they must happen, with the non-negotiable ones marked. **The ordering is doing real work**: it's what stops a reviewer from opening with style commentary on a change that was never specified.

## Output contract and boundaries

Exactly what the persona produces, meaning the artifact, its path, its required sections, and the shape of the return message. Then what it isn't allowed to touch. A persona whose write scope goes unstated will eventually write somewhere surprising.

---

# 4. Why a character

A named character is a compression device. "Channels Captain Holt" carries register, priorities, failure modes, and a tolerance for being disliked, in three words. The alternative runs two paragraphs of adjectives that the model averages into the same neutral voice every other prompt produces.

It buys three specific things.

**Consistency across invocations.** A behavioural prior anchored to a character drifts less over a long session than one anchored to a list of traits, because the character is a single coherent attractor rather than a set of independently negotiable adjectives.

**A licence to be usefully unpleasant.** This is the real reason. Most assistant output is agreeable by default, and an agreeable reviewer is worthless, since the entire value of a review is the part the author doesn't want to hear. "Holt does not let a weak answer pass" is a permission slip. A persona that refuses a thin *why*, says a gate is red, and declines to manufacture praise is doing the job. One that opens with "Great work! Just a few small suggestions" is not.

**Legible division of labour.** You know what `/holt` will do to your branch before you type it, and that predictability is most of the ergonomics.

## The guardrails

**Professionalize every trait.** Take the working habit, leave the sitcom. Holt's rigour, not his marching band.

**Substance over bit, every time.** One flourish, never in place of the explanation.

**Firm, never contemptuous.** The character is not a licence to be unkind. Assume the author was moving fast on a real problem.

**Voice colours the prose, never the verdict.** A review's findings are true or they aren't, and the character must not leak into that judgement.

**If the character is doing no work, drop it.** A persona that would behave identically named "Reviewer" should be named Reviewer.

---

# 5. The bookend pattern

Three roles, one line, one hard rule.

```
   santiago                  jake / a human                    holt
   ────────                  ──────────────                    ────
   presses on why       →    builds it              →          spec gate
   scopes                    proves it compiles                multi-lens review
   writes the spec           reports what it can't verify      runs the gates
        │                            │                              │
        ▼                            ▼                              ▼
   docs/specs/<slug>.md          the source tree          docs/reviews/<date>-<slug>.md
```

**Exactly one persona edits code.** The planner writes specs, the reviewer writes reviews, the implementer writes source. Nobody writes in two of those places, and nobody reviews their own work.

That constraint isn't tidiness. It's what makes the roster safe to run with loose permissions, because a reviewer that can edit code will fix what it finds and then report a clean review, which is precisely the failure you can't detect from the outside. Separate the write scopes and the artifacts disagree when something's wrong, and a disagreement on disk is visible.

The second effect is that each persona gets to be single-minded. A planner that will also implement starts scoping toward what's easy to build; a reviewer that will also fix starts grading toward what's easy to fix. Taking the capability away removes the incentive.

---

# 6. The handoff contract

The personas hand work to each other through artifacts rather than messages. Three rules make that work without an orchestrator.

## The slug is the edge

One kebab-case slug per unit of work, chosen by the planner and carried by everything downstream.

```
docs/specs/offline-drafts.md
docs/reviews/2026-08-09-offline-drafts.md
docs/reviews/2026-08-14-offline-drafts-2.md     ← second round, same slug
feature/offline-drafts                           ← the branch, if your conventions allow
```

Any persona can reconstruct the full history of a piece of work from the slug alone, using `ls` and nothing else. When there's no spec, the reviewer picks a kebab-case description of the change and says that it did.

## Every return message names the next hop

A persona finishes by saying who should act next and what they need. Not a dispatch, a recommendation to the human, who stays the scheduler.

| From | On | To | Carries |
|---|---|---|---|
| santiago | spec written | implementer | spec path, slug, open questions |
| jake | substantial change | holt | slug, gate results, what was left alone |
| holt | `needs-spec` | santiago | slug, the missing *why* |
| holt | `needs-work` | implementer | slug, ranked findings, which are blocking |
| holt | `ship-with-fixes` | implementer | slug, the fixes, no re-review needed |
| holt | `ship` | — | done |

Copy that table into your profile when your flow differs, whether that's an extra role, a QA step, or a required human sign-off.

## Closing the loop

**The failure mode of a review cycle is that it never terminates.** Findings, fixes, new findings, and nobody remembers what round it is. Three rules prevent it.

**A re-review reads the previous review.** Same slug, previous file. It grades the fixes and it grades what's new, and it doesn't re-litigate a finding the author already answered.

**The reviewer marks each finding blocking or non-blocking.** `ship-with-fixes` exists exactly so a round of non-blocking findings doesn't buy another full cycle.

**Three rounds means the problem is the scope, not the code.** A change still sitting at `needs-work` on a third pass goes back to the planner. Say so explicitly rather than starting a fourth round.

## What this isn't

No state file, no run ID, no automatic transition. If you want a harness to execute the table above, whether that's a workflow script, a CI job, or a `make review`, build that adapter *on top of* the declared handoffs and never inside the persona documents. The personas have to keep working when the adapter isn't there.

---

# 7. Ranked ladders

Every reviewing document needs an explicit ranking of what matters, because findings compete and the default ordering is whatever was easiest to notice. Which is formatting, always.

A ladder does three jobs: it decides ties, it sets what leads the report, and it tells a persona where to spend a limited change budget.

## The universal ladder

Worst first. A repo profile can insert rungs, reorder them, or override the list outright, as long as it says so and doesn't move formatting off the bottom.

1. **Correctness and data loss.** The change doesn't do what it claims, or it corrupts, destroys, or leaks data. Nothing outranks this.
2. **Security at a trust boundary.** Anything crossing from untrusted to trusted: input handling, authentication, authorization, secrets, deserialization, injection. Ground each finding in a concrete exploit rather than a category name.
3. **Resource and lifetime discipline.** Anything acquired and not released, meaning connections, handles, locks, subscriptions, timers, goroutines, listeners. Concurrent access with no discipline. Async work that outlives whatever started it.
4. **Error handling.** Swallowed errors, errors handled at a layer that can't act on them, failure paths that strand the system somewhere unrecoverable, retries without bounds.
5. **Contract and compatibility.** API, schema, wire-format, and migration changes. What does an old client or a half-migrated database do, and is the change reversible?
6. **Structure.** Single responsibility, layering violations, premature abstraction, scope creep. A diff much larger than the feature warrants is itself a finding.
7. **Language idiom and types.** Escape hatches from the type system, unidiomatic constructs, ignored warnings.
8. **Tests.** Missing coverage of the behaviour that changed, tests that assert on implementation details, tests that still pass with an assertion removed.
9. **Naming, comments, and docs.** Real findings, ranked here. Comments that restate the code, argue with a reviewer, or run longer than what they introduce.
10. **Formatting.** Not a finding. The formatter owns it, and a persona that reports formatting has told you it had nothing better to say.

## Writing a good rung

A rung earns its place when it names the symptom, the consequence, and where it shows up. Compare:

> **Bad:** Effects should be cleaned up.
>
> **Good:** A subscription, listener, timer, or animation with no cleanup; `setState` synchronously in an effect body; an effect used to compute derived state. On a phone these become battery drain, stuck screens, and crashes that only reproduce after ten minutes of use.

The second is checkable. The first is a slogan.

---

# 8. Verify, don't assume

The highest-value behaviour in the roster, and the one most worth copying into anything you build.

**Gates are real commands with real output.** The profile names them, the persona runs them and reports what actually happened. Never "typecheck passes" from inspection. Run it, paste the outcome. A persona that can't run a gate says so and names it as unverified.

**A red gate is a finding.** Not a footnote, and not "unrelated" unless the persona demonstrates that it's unrelated, which usually means showing it was red before the change.

**Trace the path for every correctness claim.** "Looks fine" is not a review. Asserting a bug requires the concrete input, state, or interaction that triggers it. Where the trace stopped short, label it: *I did not follow the error path through the retry wrapper.*

**Name what can't be verified from here.** Device behaviour, production load, a real payment provider, anything behind a credential the persona doesn't have. Say it plainly and tell the human what to check. A claimed fix that was only reasoned about is worse than an honest gap, because it stops anyone else from checking.

**No manufactured findings.** A clean review is a valid and useful result. Padding a report to look thorough trains everyone to skim it.

---

# 9. Anatomy of a skill

A skill is the rubric for one dimension, shared by every persona. Personas hold role and workflow; skills hold standards. That split is why three personas can apply the same security standard without three copies of it drifting apart.

**It's also the only extension point you need.** The personas ship generic and specialize entirely through the lenses the profile names, so adding a skill requires changing no persona and never will. Catch yourself editing a persona to teach it about your stack and the thing you wanted was a skill.

## Three tiers

| Tier | True for | Examples | Lives |
|---|---|---|---|
| **Universal** | every codebase | `ticket-writing`, `spec-driven-development`, `mermaid-diagrams`, `clean-code`, `security-expert`, `commit-conventions` | ships with the roster |
| **Stack** | one language or framework | `effective-go`, `effective-typescript`, `react-native-expo` | the repo, or a shared library |
| **Repo** | one codebase | `check-helm-config`, `audit-the-deploy-manifests` | the repo, always |

The universal tier is *role*-adjacent, since every reviewer and planner everywhere needs it, which is why those six travel with the personas. The stack tier ports between repos that share a stack but belongs to nobody in particular, so copy it or write it from the template. The repo tier never leaves home.

**Most of what makes a reviewer feel sharp lives in tier two.** A generic reviewer with a good profile catches structure and process problems. Catching the mistake that only looks wrong to someone who has shipped in that ecosystem takes a stack skill.

## Structure

```
skills/<name>/
├── SKILL.md            the rubric, loaded whenever the skill is invoked
└── references/         loaded on demand, when the rubric points at them
    ├── canon.md        fetchable primary sources, with URLs
    └── <catalog>.md    long lookup tables, playbooks, worked pairs
```

Keep `SKILL.md` to what's needed *every* time and push catalogues, playbooks, and worked before/after pairs into `references/`. A rubric too long to read gets skimmed, and the skimmed part is the part that mattered.

## The two modes

Every rubric skill declares both, up top. **Adhere** is a checklist while writing or refactoring. **Validate** is a procedure while reviewing a diff, producing ranked findings rather than a rewrite.

Same standards, different verb. Without the split, a skill written for review gets applied as a rewrite mandate, and a skill written for authoring produces no findings at all.

## Canon over memory

The most valuable thing in a skill is a list of primary sources with URLs, plus an instruction to read them rather than recall them:

> Before writing against any framework API, read the *versioned* documentation for the version pinned in this repo. Not a blog post, and not remembered advice from an older release.

Model recall of fast-moving ecosystems is confidently wrong at exactly the version boundaries that matter. A `references/canon.md` turns "I think it works like this" into a fetch. It also settles disputes, because a persona that can quote the rule doesn't have to win on tone.

## Guardrails

Close every skill with its own limits: when *not* to apply it, what overrides it, and what it must not justify. A rubric with no stated limits gets applied everywhere, which is how a codebase ends up with an interface per class.

## Authoring a skill

Start from [`templates/skill/`](templates/skill/), with [`examples/skills/effective-go/`](examples/skills/effective-go/) open beside it as a worked one. Copy the directory, rename it for the standard rather than the technology (`effective-go`, not `golang-helper`), fill it in, then add it to your profile's lens table with the condition under which it applies. That's the entire wiring.

**Build the ladder from incidents, not from a style guide.** This is what separates a skill that produces findings from one that produces platitudes. Your source material is what has actually broken in production here, what has been caught late in review more than once, and what every new joiner gets wrong in their first month. A style guide tells you what the community prefers. An incident list tells you what this ecosystem punishes.

Rank by consequence rather than frequency, so a rare data-loss bug outranks a common naming problem. Cap it around seven rungs, because nobody holds more than that in their head and a ladder nobody remembers decides nothing.

**Write rungs that are checkable.** The test is whether a reviewer could point at a line and say "that's rung two". Name the symptom, the consequence, and where it shows up:

> **Bad:** Resources should be cleaned up.
>
> **Good:** A connection, handle, lock, or subscription acquired without a matching release on every path, including the error path. Shows up as pool exhaustion under load, hours after the deploy, on the request that was already slow.

**Put the catalogue in `references/`.** `SKILL.md` holds what's needed every time: the ladder, the checklist, the smells, the guardrails. Worked pairs, long lookup tables, and per-class playbooks load when the rubric points at them.

**Fill in `references/canon.md` if the ecosystem moves.** Pin the documentation URL to the version this repo actually uses. That's what lets a persona settle a disagreement by quoting the rule instead of asserting taste, and it's the difference between "I believe this is idiomatic" and "I checked, and I was wrong", which is a far more useful sentence.

Then use it on a real diff before you trust it. A rubric that has never produced a finding is a guess about what matters.

---

# 10. The profile

`.agents/profile.md` is the one file each consuming repo writes, and it's what makes a generic persona sharp. [`templates/profile.md`](templates/profile.md) has the full form. The sections:

| Section | Answers |
|---|---|
| Stack and authority | What this is, and which file wins on conflict |
| Paths | Where specs, reviews, and generated code live, plus the ticket prefix. `Specs: none` turns the spec gate off for repos that don't write them, and the *why* still gets pressed |
| Reference codebase | A codebase outside this repo that personas read as source material, such as a prototype being ported. Optional, and the thing most often missing when a repo is new enough that researching it finds nothing |
| Gates | The exact commands, and when each applies |
| Lenses | Which skills apply to what, including this repo's local stack skills |
| Spec-worthy | What triggers the spec gate *here* |
| Hazards | What actually bites in this codebase |
| Handoffs | The edge table, when it differs from the default |
| Escalate elsewhere | Findings that belong in another repo's tracker |

## When there's no profile

Personas degrade honestly, never silently. The contract has four parts.

**Infer what's inferable** from build and CI files, meaning the package manifest, the `Makefile`, the CI workflow. That's usually enough to find the real gate commands.

**State the inference in the output.** *No profile found; I inferred the gates from the CI workflow and used `docs/specs/` by convention.*

**Never invent a gate command.** If you cannot find a test command, report tests as unverified.

**Offer to write the profile** once, at the end, rather than as a blocking question.

## Why not generate the personas instead

Because a generated file is a file someone will edit, after which the generator's output and the edited copy disagree forever. Reading a profile at invocation costs a little context per run and removes that entire class of drift. Upgrading the roster then never touches a repo's customization, since the customization lives in a file the roster doesn't own.

---

# 11. Harness mapping

The personas are markdown with YAML frontmatter. What varies per tool is only where the file goes and how it's invoked.

| Harness | Personas go | Invoked as | Notes |
|---|---|---|---|
| Claude Code | `.claude/agents/` | subagent, or `/holt` via `.claude/commands/` | Symlink into `.agents/`; frontmatter `name` is the handle |
| Claude Code plugin | plugin `agents:` manifest | `/plugin install`, then as above | Upgrades handled by the plugin system |
| Cursor | `.cursor/rules/` | referenced in chat | Frontmatter differs, body ports as-is |
| Codex and other `AGENTS.md` readers | `AGENTS.md`, or a file it points at | pasted or referenced | Point at `.agents/` from the root file |
| Copilot | `.github/copilot-instructions.md` | implicit | Suits one always-on persona, not a roster |
| Aider, Cline, others | a conventions file | pasted | The body is the prompt |
| No harness at all | anywhere | paste into a chat, or read it yourself | The body is a complete instruction set |

**One rule keeps this manageable.** The real file lives in `.agents/`, and every vendor directory holds nothing but relative symlinks back to it. Never a second copy. Commit both the file and the link, which git stores as mode `120000`.

```bash
ln -s ../../.agents/personas/reviewer.md .claude/agents/reviewer.md
```

Where a tool has no subagent concept, a persona is just a prompt: paste the body, give it the target, and it works, with less isolation since it shares the conversation's context. That degradation is acceptable, and it's the reason the body never depends on harness features.

---

# 12. Anti-patterns

Learned by watching these drift.

**Persona sprawl.** Six personas where three would do. Every extra persona costs dispatch ambiguity, so the human hesitates, the router guesses, and two of them do overlapping work. Add one only when a role has a genuinely different write scope or a genuinely different failure mode. "It'd be nice to have a testing persona" isn't a reason. "Nobody owns the question of whether the tests assert anything" might be.

**Personality over substance.** Jokes, catchphrases, and in-references crowding out the explanation. The test: strip every character reference from the document, and if what's left isn't a strong, complete instruction set, the character was carrying weight it shouldn't have been.

**Fusing stack into persona.** The original sin this repo exists to fix. The moment a persona hardcodes `npm run typecheck` it forks per repo, and the forks diverge on the parts that were supposed to be shared.

**A persona that writes and reviews.** Covered in §5, repeated here because it's the most tempting shortcut in the set. It always looks like efficiency and it always destroys the signal.

**Unrunnable gates.** A gate command that doesn't exist, needs a credential nobody has, or takes forty minutes. First it gets skipped, then it gets skipped silently, and then the definition of done means nothing. Gates in the profile have to be commands the persona can actually run, now.

**The rubric with no limits.** A skill that says only "extract, abstract, cover" and never "here's when not to" produces a codebase of one-caller helpers and interfaces with a single implementation.

**Reimplementing an orchestration framework.** The drift path for this repo specifically. Watch for a state schema, a run ID, retry policy, a DSL, a `personas.lock`. Any phase that tempts you toward those wants a harness-specific adapter on top of the declared handoffs, never something inside the persona files.

**Specs and reviews nobody reads.** Artifacts that go unconsulted make the roster theatre with extra steps. The slug convention is what makes them findable, and a review not linked to its spec by slug is already lost.

---

# 13. Adding a persona

The bar: a distinct write scope, a distinct failure mode it exists to catch, and a one-sentence answer to "why isn't this a lens on an existing persona?"

**Most candidates fail that last test.** A security specialist, a performance specialist, an accessibility specialist are usually skills the reviewer already invokes rather than people. Promote a lens to a persona when it needs its own workflow and its own artifact, not when it needs emphasis.

Clearing the bar means five steps.

1. Write `personas/<role>.md` with the six parts from §3. File named for the role, frontmatter for the character.
2. Write `commands/<name>.md`, a thin wrapper that dispatches the persona, restates the non-negotiable workflow steps, and says what to relay back. Not a second copy of the persona, just the checklist for a single invocation.
3. Add the persona's edges to the handoff table in §6 and to `templates/profile.md`.
4. Add it to the plugin manifest and to `install.sh`.
5. Update the roster table in the README.

Then use it on something real before you commit it. A persona that has never been invoked in anger is a guess about what a role should do.
