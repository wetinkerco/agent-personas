---
name: <kebab-case-name>
description: >-
  <One sentence: what standard this enforces and for what.> Use when writing, refactoring, or
  reviewing <what>. Covers <the three to six areas, named>. Triggers on <the phrases a user
  actually types>, or any diff touching <the paths or file types>. <Name the authority that wins
  on conflict, usually the repo's house rules.>
---

<!--
  SCAFFOLD. Delete every comment block before committing.

  This is the shape of a RUBRIC skill: a standard that personas apply while writing (adhere) and
  while reviewing (validate). Most skills are this kind. For a PROCEDURE skill, meaning one that runs a
  specific check or task rather than grading code, keep the frontmatter and the guardrails,
  replace the two modes with numbered steps, and say what it outputs.

  Name the file's directory for the skill. Name the skill for the standard, not the technology:
  `effective-go`, not `golang-helper`. The name is what a persona invokes and what the profile's
  lens table references.

  Target length: 150-250 lines. Past that, move material into references/. A rubric too long to
  read gets skimmed, and the skimmed part is the part that mattered.
-->

# <Skill name>

Two modes. **Adhere** while writing or refactoring. **Validate** when reviewing a diff.

<!--
  State the skill's territory and its neighbours in one short paragraph. Every skill overlaps
  with something; say which one wins where, so a persona holding three lenses doesn't have to
  guess. Then name the authority above you.
-->

This skill is the rubric for **<the one dimension it owns>**. `<neighbour skill>` is the rubric for `<their dimension>`. They overlap deliberately, and when they do, **prefer the more specific one**. The house rules named in `.agents/profile.md` **win on any conflict**.

<!--
  If the standard has primary sources, say so here and point at references/canon.md. This is what
  turns "I think it works like this" into a fetch, and it is what lets the skill settle a dispute
  without winning on tone.
-->

**<Ecosystem> moves, and this repo is pinned.** Before writing against any API, read the *versioned* documentation for the version in `<the manifest>`, not a blog post and not remembered advice from an older release. `references/canon.md` has the source list.

---

## The ladder, ranked

<!--
  THE MOST IMPORTANT SECTION. Findings compete, and the default ordering is "whatever was easiest
  to notice", which is formatting, always. The ladder decides ties, sets what leads a report, and
  tells an implementer where to spend a limited change budget.

  How to build one for a stack you know:

  1. Start from the bugs that actually shipped. Not a style guide, an incident list. What has
     broken in production, what has been caught late in review twice, what does every new joiner
     get wrong in their first month.
  2. Rank by consequence, not by frequency. A rare data-loss bug outranks a common naming problem.
  3. Cap it at seven rungs. More than that and nobody holds the order in their head, which defeats
     the purpose.
  4. Put formatting last and mark it "not a finding". Every ladder needs that floor stated
     explicitly or it will fill up with whitespace commentary.
  5. Check it against the universal ladder in GUIDE.md §6. You are specializing that ladder for
     one dimension, not replacing it. If your rung 1 is below its rung 4, say why.

  A rung is useful when it names the SYMPTOM, the CONSEQUENCE, and WHERE IT SHOWS UP:

    BAD:  Resources should be cleaned up.
    GOOD: A connection, handle, lock, or subscription acquired without a matching release on
          every path including the error path. Shows up as pool exhaustion under load, hours
          after the deploy, on the request that was already slow.

  The second is checkable. The first is a slogan.
-->

When findings compete, this is the order that matters.

1. **<Rung 1: the one that causes data loss or corruption.>** <The specific symptoms. The consequence in concrete terms. Where it shows up.> Nothing outranks this.
2. **<Rung 2.>** <...>
3. **<Rung 3.>** <...>
4. **<Rung 4.>** <...>
5. **<Rung 5.>** <...>
6. **<Rung 6: naming, comments, documentation.>** <Real findings, but they grade below correctness.>
7. **Formatting.** Not a finding. The formatter owns it.

---

## Adhere: checklist while writing

<!--
  Group by the units the reader actually works in. For a language skill that is usually
  modules / functions / types / errors / concurrency / tests. Keep each item to one or two lines
  and make it an instruction, not an observation.

  Every item should pass this test: could a reviewer point at a line of code and say "this
  violates that"? If not, it is a value, not a rule, and it belongs in the intro paragraph.
-->

### <Area, e.g. Modules and files>

- <Rule. Imperative. Checkable.>
- <Rule, with the reason compressed into the same line where the reason is not obvious.>

### <Area, e.g. Functions>

- <...>

### <Area, e.g. Errors>

- <...>

### <Area, e.g. Tests>

- <...>

---

## Validate: reviewing a diff

Produce **findings, not a rewrite**.

1. Read the diff **and** the files it touches.
2. Walk **Adhere** against the change, only where it applies.
3. Grade by **the ladder**, worst first.
4. Report only real, actionable findings. **Skip anything the formatter or linter already owns.**
5. Each finding: `file:line`, the rule, why it bites in concrete terms, the specific fix.
6. If it is clean, say so, and do not manufacture findings.

### Smells to flag

<!--
  The recognizable shapes, phrased so they can be spotted in a diff rather than reasoned about
  from first principles. This is the section reviewers actually use. Aim for 8-15 entries, each
  one thing you have genuinely seen go wrong here.
-->

- <The shape, named concretely enough to spot.>
- <...>

---

## Guardrails

<!--
  Never ship a rubric without limits. A skill that only says "extract, abstract, cover" and never
  "and here is when not to" produces a codebase of one-caller helpers and interfaces with a single
  implementation. State what overrides this skill, when not to apply it, and what it must not be
  used to justify.
-->

- **The house rules override any rule here.** When this skill says `<X>` and the house rule says `<not X>`, follow the house rule.
- **Do not clean unrelated code during a focused task.** Note it, move on.
- Prefer the smallest change that removes the smell. Never rearchitect to satisfy a rule.
- <A limit specific to this skill: the thing it would otherwise be used to over-justify.>

<!--
  BEFORE YOU COMMIT:

  - Delete every comment block, including this one.
  - Add the skill to your profile's lens table, with the condition under which it applies:
        | language idiom | <name> | any <.ext> diff |
  - If it needs sources, fill in references/canon.md. If it does not, delete that file.
  - Use it on a real diff before you trust it. A rubric that has never produced a finding is a
    guess about what matters.
-->
