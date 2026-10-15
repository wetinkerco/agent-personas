---
description: Review changes with the Holt code-reviewer persona
argument-hint: "[branch | PR# | path — defaults to the current branch's uncommitted changes]"
---

Launch the **holt** persona (via the Agent tool, `subagent_type: holt`) to review: $ARGUMENTS

If no target is given above, review the uncommitted changes on the current branch, meaning the working tree diff against `HEAD`.

Have Holt run his full review:

1. **Read `.agents/profile.md` first** for gates, lenses, paths, spec-worthy criteria, hazards, and what cannot be verified here. If there is no profile, infer the gates from the build and CI files and **say so explicitly in the review**. Never invent a command.
2. **SDD spec gate first.** Confirm the work is specified against the profile's spec-worthy list, or that it is a deliberate spec-light change with the *why* on record. A missing spec on spec-worthy work is the headline finding rather than a footnote. **Skip this step entirely if the profile says `Specs: none`**, since that repo does not write specs and it is not a finding.
3. **Multi-lens review, ranked.** The profile's language and framework lenses, plus `clean-code` for structure and a `security-expert` pass on any trust-boundary change. Grade by the universal ladder as modified by the profile: correctness and data loss, security, resource and lifetime discipline, error handling, contract and compatibility, structure, idiom and types, tests, naming and comments. Formatting is never a finding.
4. **Walk the profile's hazard list** against this diff explicitly.
5. **Verify the Definition of Done rather than assuming it.** Run every applicable gate from the profile and report the actual output. A red gate is a finding, and a gate that could not be run is reported as unverified rather than as passing.
6. **Press on the why** for anything that adds complexity, a dependency, or a new pattern.
7. **Write the review** to `<reviews path>/YYYY-MM-DD-<slug>.md`, with each finding marked blocking or non-blocking.

If a review already exists for this slug, have him read the most recent one first and grade the fixes rather than re-litigating answered findings.

When Holt finishes, relay his verdict, the gate results, and the headline findings rather than his full transcript. Call out separately anything he flagged as belonging in another repo's tracker, and **name the next hop**: `needs-spec` goes back to `/santiago`, `needs-work` goes back to `/jake` or whoever implemented it. He reviews only; he does not edit code.
