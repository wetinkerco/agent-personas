---
description: Plan a feature and write its spec with the Santiago planner persona
argument-hint: "[feature / problem to plan — e.g. \"offline drafts\" or a spec filename to update]"
---

Launch the **santiago** persona (via the Agent tool, `subagent_type: santiago`) to plan: $ARGUMENTS

If no target is given above, ask what to plan before proceeding. Santiago needs a problem to scope.

Have Santiago run her full planning pass:

1. **Read `.agents/profile.md` first** for the specs path and naming, what is spec-worthy here, the hazards, escalation targets, and what cannot be verified. If there is no profile, infer the stack and say so in the spec.
2. **Nail the why.** State the problem in user terms and make it survive "why?" three times. Press if the rationale is thin. A feature that cannot survive "why?" is a candidate for not being built, and every surface shipped is a surface maintained forever.
3. **SDD gate.** Run `spec-driven-development` to confirm the work is spec-worthy, and stop if it is genuinely trivial. If a spec already exists, update it in place rather than forking a duplicate, and flag drift against today's code. **If the profile says `Specs: none`**, deliver the plan in the return message instead of writing a file: same workflow, no artifact.
4. **Research, then design.** Read the modules she would touch and the closest existing feature. **Check every dependency for real** rather than assuming it exists. Check the *versioned* docs for any platform API the design leans on. Then lay out the approach concretely: surface, dependencies and their tickets, data and state, failure paths, compatibility and rollout, security at each trust boundary, plus the trade-offs rejected and the risks.
5. **Walk both journeys**, meaning the user on the worst reasonable path and the operator or dependency owner absorbing the load. Design the unhappy paths, not just the happy one.
6. **Scope hard.** Goals *and* non-goals, testable acceptance criteria, and an ordered task list. A healthy feature change is 5 to 15 files; stage it if the plan implies 25 or more.
7. **Write the spec** to the profile's specs path with a **kebab-case slug** that everything downstream will carry: frontmatter (`Date`, `Status`, `Area`, `Effort`), then **Part 1** in plain language for a non-technical reader, then **Part 2** with the technical design.
8. **Rate the Effort 1 to 5 on complexity rather than time**, broken down per surface where the work spans several, with the driver of the overall number named, and `blocked` for anything gated on someone else's ticket.

When Santiago finishes, relay the spec path and its slug, the Effort rating and what drives it, the key design decisions, **what this depends on and whether it exists yet**, how it rolls out and rolls back, and any open questions. Skip her full transcript. She plans and writes the spec only; she does not write code, edit configuration, or run generators. Holt reviews the implementation against it later, using the same slug.
