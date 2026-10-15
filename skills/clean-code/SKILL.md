---
name: clean-code
description: >-
  Apply and validate Clean Code and SOLID principles when writing, refactoring, or reviewing code
  in any language. Use when authoring non-trivial code, when the user asks to "review", "clean
  up", "refactor", or "validate" code against clean-code standards, or before opening a PR.
  Covers modules, functions, naming, errors, data, and tests, plus SOLID read through whatever
  paradigm this repo actually uses. Language- and stack-agnostic; the repo's house rules and its
  local idiom skill win on any conflict.
---

# Clean Code & SOLID

Two modes. **Adhere** while writing or refactoring. **Validate** when reviewing a diff.

This skill is the rubric for **structure and design**. The repo's language-idiom skill is the rubric for *language idiom*, and its framework skill for *runtime behaviour*. They overlap deliberately, and when they do, **prefer the more specific one**. The house rules named in `.agents/profile.md` are the style authority and **win on any conflict**, including against every instinct here to extract, layer, or generalize.

Source material: R. C. Martin's *Clean Code* and SOLID, read through the paradigm this codebase actually uses, which is usually not the one the book assumed.

---

## Translate before you apply

Classic Clean Code assumes classes, inheritance, and exceptions. Most codebases are not that. Do this translation first, then apply the rules.

| Clean Code says | In a class-based codebase | In a module/function codebase |
|---|---|---|
| Class has one responsibility | Class has one responsibility | **Module (file)** has one responsibility |
| Program to an interface | Interface or abstract base | The narrowest parameter type the consumer needs |
| Dependency injection container | Constructor injection | Parameters, closures, or a small explicit context |
| Inheritance / template method | Prefer composition | Composition: pass a function, wrap a value |
| Extract a class | Extract a class | Extract a **function** first. A new module only when it is a genuinely separate concern |
| Throw exceptions | Throw at the boundary | Return an error value; handle at the boundary |
| Null object pattern | A null object | A tagged union or option type with an explicit empty case |

**The "extract a class" row is the one most often violated.** The answer to "this file is getting big" is usually *pull the logic into a function in the same file*, not a new directory of five files.

---

## Adhere: checklist while writing

### Modules and files

- One module, one reason to change.
- **Respect the layering** the repo already has. A file in the outermost layer that hand-builds a request, or a data-access file that also formats output, is in the wrong layer.
- **A 250-line file beats five 50-line files.** Combine related code; split by responsibility, not by symbol count.
- **No `utils`, `helpers`, `common`, `shared`, `misc` modules.** Name the file for the concept: `format/phone-number`, not `utils/index`.
- No barrel re-export files. They hide the dependency graph and, in bundled languages, cost size.
- Colocate: a thing's sub-parts live beside it until a second consumer appears.

### Functions

- Small, one thing, one level of abstraction. If you need "and" to describe it, split it.
- **Three parameters or fewer**; past that take an options object or a struct. **No boolean flag parameters.** A flag that changes what the function *is* means it is two functions.
- **No hidden side effects.** A function named `get*` must not write.
- **Keep I/O at the edges.** A pure function that takes data and returns a decision is testable without a single mock; push the network, clock, filesystem, and database calls out to the caller.
- Caller above callee; declare variables near first use.

### Naming and comments

- Intention-revealing, pronounceable, searchable. **One word per concept.** Pick `get` or `fetch` or `load` and use it consistently across the module.
- Named constants over magic numbers and repeated string literals.
- **Comments default to none.** When one earns its place, make it one line, and have it explain *why*. A comment that restates the code is a naming failure, so rename or extract instead. Delete commented-out code and "removed X" tombstones.

### Errors and state

- **Handle once**, at the layer that can do something about it. Do not catch, log, and rethrow the same error at three levels.
- Guard clauses, not nested conditionals.
- **One source of truth per value.** Copying a value into a second place that must be kept in sync is the most common source of "it shows stale data".
- **Validate at the boundary.** User input, stored data, messages from other systems, then trust the types inward. Do not re-validate the same field in three layers.
- Make illegal states unrepresentable where the language allows it: a tagged union beats a bag of optional fields that only make sense in certain combinations.

### Data and types

- **DRY at the third repetition.** Two is a coincidence. Prefer two similar things that are free to diverge over one shared thing with a `mode` parameter that grows a branch per caller.
- **Derive types from the generated or canonical source** rather than hand-copying a shape that will drift.
- Encapsulate a meaningful primitive into a named type when it stops invariants from leaking.

### Tests

- **FIRST**: Fast, Independent, Repeatable, Self-validating, Timely.
- Test **observable behaviour**, not internal calls. Asserting that a collaborator was called is usually asserting the implementation.
- Mock only external boundaries: the network, the clock, the filesystem, the database. **If a test needs more than three mocks, the design is wrong, so fix the design.**
- No helper, factory, or fixture until three tests need it.

---

## SOLID

Stated for classes, translated for everything else.

- **S, single responsibility.** A module, function, or type has one reason to change. Something that fetches, maps, formats, *and* presents is four things.
- **O, open/closed.** Extend by composition, whether that means passing a function or adding an entry to a lookup table, rather than by growing a `switch` that every new case must edit. A map from case to handler is the idiomatic form in most languages.
- **L, Liskov substitution.** Anything accepted where a general type is expected must actually behave like one. A "shared" component whose `mode="compact"` silently ignores half its inputs is a broken abstraction, so split it.
- **I, interface segregation.** Parameters typed to what is actually used. Passing a whole `User` where the function reads two fields couples it to every future change to `User`.
- **D, dependency inversion.** Depend on the narrow thing you need, not the concrete infrastructure. Something that reaches directly for the database connection cannot be tested, reused, or run anywhere else.

---

## Validate: reviewing a diff

Produce **findings, not a rewrite**.

1. Read the diff **and** the files it touches.
2. Walk **Adhere** and **SOLID** against the change, only where each applies.
3. Check the scope signals: **5–15 files is healthy** for a feature, 15–25 warrants a hard look, 25+ is over-engineered and should be split. A diff far larger than the feature warrants is itself a finding.
4. Report only real, actionable findings. **Skip anything the formatter or linter already owns.**
5. Each finding: `file:line`, the principle, why it bites in concrete terms, the specific fix.
6. Rank by severity. If it is clean, say so, and do not manufacture findings.

**Severity ladder for framing**, worst first: **rigidity** (hard to change), **fragility** (changing it breaks something elsewhere), **needless complexity**, **repetition**, **opacity** (hard to read). Lead with the smell that costs the most.

### Code smells to flag

- A single unit that fetches, transforms, branches, and presents at mixed abstraction levels.
- A "shared" thing with a `variant` / `mode` / `type` parameter and a branch per consumer.
- Long parameter lists; boolean mode parameters; values threaded through three layers that want a different structure.
- An extracted helper with one caller that only exists to shorten a file.
- Duplicated formatting or mapping logic across modules.
- Two sources of truth for the same value; a cache nobody invalidates.
- **Leaky abstraction.** Transport errors, database types, or generated wire types reaching into presentation code.
- **Speculative generality, the biggest offender.** A `Provider`, `Factory`, or `Manager` with one implementation and no second caller. A new directory holding two small files. A wrapper that only forwards its arguments.
- Business logic in a layer that should be thin.
- Dead code, inconsistent naming, magic numbers, `TODO` with no owner.
- Tests that assert on implementation details, or that still pass with an assertion removed.

---

## Guardrails

- **The house rules override any rule here.** When this skill says "extract" and the house rule says "inline it", inline it.
- **Do not clean unrelated code during a focused task.** Note it, move on. Scope discipline beats purity, and a large "while I was in here" diff is itself a review finding.
- Prefer the smallest change that removes the smell. Never rearchitect to satisfy a rule.
- The test for any new abstraction: **would a senior reviewer delete this in review?** Then do not add it.
