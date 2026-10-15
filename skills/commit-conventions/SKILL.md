---
name: commit-conventions
description: >-
  Name commits and branches. Enforces Conventional Commits 1.0.0 — one type, at most one scope,
  a lowercase one-line subject, no body — plus a branch form that carries the ticket and the spec
  slug, and git's own ref-name rules. Use before every commit, before creating a branch, and when
  titling a PR that will be squash-merged. Triggers on "commit this", "write a commit message",
  "start a branch", "what should I call this branch", or any review of a branch or PR. **Commit
  messages carry no agent attribution**: no `Co-Authored-By` for a tool, no generator line, no
  session link. Reads `.agents/profile.md` for the scope vocabulary and branch form.
---

# Commit Conventions

Two modes. **Adhere** when committing or branching. **Validate** when reviewing a branch or PR.

This skill owns **the names git carries**: the commit subject and the branch. `ticket-writing` owns the task and its identifier, `spec-driven-development` owns the slug. This skill spends both — a commit that references a ticket and a branch that carries the slug are what make the ticket, the spec, the branch, the commit, and the review findable from any one of them. That chain is the whole point; everything below is in service of it.

The house rules named in `.agents/profile.md` **win on any conflict**, with one exception, stated in *Attribution* below.

**These are enforceable standards, not taste.** `references/canon.md` has the sources. Fetch them before disputing a rule here.

---

## The ladder, ranked

When findings compete, this is the order that matters.

1. **The message misrepresents the change.** A `fix:` whose gate was never run, a `refactor:` that changed behaviour, a `perf:` with no measurement, a subject describing something the diff does not do. The log is the only account of why the code is the way it is, and a false entry is worse than no entry — it is believed. Nothing outranks this.
2. **Attribution that isn't the author's.** An agent, tool, or session credited as a co-author. It puts a non-person in the contributor graph and `git shortlog`, and it detaches accountability from the person who ran the change and shipped it.
3. **The commit is not one logical change.** Unrelated files swept in by `git add -A`, two features in one commit, a fix buried inside a refactor. This is what makes a revert impossible and a bisect useless, months later, when both are the only tools left.
4. **Broken convention grammar.** A chained type, a type outside the enum, a breaking change with no `!` or `BREAKING CHANGE:` footer. Release tooling reads these literally: the wrong type ships the wrong semver bump, and a missed breaking marker ships a major change as a patch.
5. **A branch name that breaks the index or the tooling.** No ticket reference, a slug that matches no spec, uppercase on a case-insensitive filesystem, a character git rejects.
6. **Subject style.** Case, mood, trailing period, length. Real findings, and they grade below every one above.
7. **Wording preference on an otherwise correct message.** Not a finding. If it parses, it is true, and it names the change, leave it alone.

---

## Adhere: the commit message

### The subject is the whole message

One line. No body. A commit message is an index entry, not a document.

```
<type>[(scope)][!]: <description>
```

The context that would have gone in a body already exists somewhere better: the ticket holds the *what* and the *why*, the spec holds the design, the review holds the findings, the diff holds the change. Restating any of it in a commit body creates a copy that starts drifting the moment it is written, and nobody updates a commit message — it is the one artifact in this system that is immutable by convention.

So **reference, don't restate**. If the change needs a paragraph because the reasoning is subtle, that reasoning belongs in the spec and the commit points at it. If it needs a paragraph because it does several things, it is several commits.

A body or footer is warranted in exactly four cases, and all four are machine-read rather than prose:

| Case | Form |
|---|---|
| Breaking change | `BREAKING CHANGE: <what breaks and what to do>` as a footer, with `!` before the colon |
| Closing a tracker item | `Closes #412` / `Fixes #412`, the keyword the tracker actually parses |
| Referencing without closing | `Refs: ENG-412`, `Spec: docs/specs/token-refresh.md` |
| A revert | whatever `git revert` generates, which names the reverted SHA — keep it |

Trailers, not prose. One blank line before them, `Token: value` per line, hyphens instead of spaces inside the token.

### Where the ticket id goes: not the front

**The type starts the header. That position is fixed and it is the only one the grammar fixes.** `ENG-412 feat(auth): add refresh` does not parse: commitlint reads the type as everything before the first `(` or `:` and rejects it against the enum, and semantic-release finds no type, so it ships no version at all. A leading id costs you the machine-readability that taking the convention bought.

It buys nothing back, either. **Every major tracker matches the id anywhere in the message**, so the front is not a functional position, only a conspicuous one:

| Tracker | What it matches | Catch |
|---|---|---|
| GitHub | `#412` anywhere; a closing keyword (`closes`, `fixes`, `resolves`) closes the issue when the commit lands on the default branch | `fix` is *itself* a closing keyword, so never put a bare `#412` next to the type |
| Jira | the key anywhere — the documented syntax is literally `<ignored text> <ISSUE_KEY> <ignored text>` | Smart Commit commands must follow the key |
| Linear | the id in the branch name, the PR title, the PR description, or a commit message | in a commit it needs a **magic word before the id** (`refs ENG-412`), so a bare `(ENG-412)` does not link |

So, in order of preference:

1. **Leave it off the commit entirely.** The branch carries the id, and on a squash repo the branch and PR title carry it into the trunk commit — the one that survives. Paying twelve characters of a seventy-two character budget to say what the branch already says is the common mistake here, not the position it is said in.
2. **End of the description, in parentheses**, when individual commits land on the trunk (a merge-commit or rebase repo) and the branch is then deleted: `feat(auth): add silent token refresh (ENG-412)`. Valid grammar, still one line, still greppable.
3. **A trailer**, when this commit should *close* the item, or on Linear where a bare reference does not link: `Closes #412`, `Refs: ENG-412`. Deliberate, and on exactly one commit — the keyword is what does the closing, so it should not be sprayed across five.

Never in the scope. `feat(ENG-412): …` parses, and it spends the one field whose whole job is grouping changes by area on a value that is unique per change.

The profile decides which of the three this repo does. If a hook appends the id from the branch name automatically, that is the cleanest form of option 2 and nobody has to remember it.

### Grammar: one type, at most one scope, never chained

Conventional Commits 1.0.0 gives you exactly one type and at most one scope. `fix: feat(auth): add refresh` is not a compound — the grammar takes everything after the first `: ` as the description, so a parser reads that as type `fix`, description `feat(auth): add refresh`, and the release tooling bumps the wrong number. There is no chaining because two types means two commits.

- **Type**: required, lowercase, from the closed enum below.
- **Scope**: optional, one, a lowercase noun in parentheses naming a section of the codebase. Use the closed list in the profile. Without a closed list, scopes sprawl into `(auth)`, `(authentication)`, and `(Auth)` inside a month and stop being groupable, which was their only job. Omit the scope when the change spans several or when the repo doesn't use them.
- **`!`**: before the colon, when this breaks something a consumer depends on.

### The types, and the trap in each

| Type | Use for | The trap |
|---|---|---|
| `feat` | new capability a user or caller can reach | drives the minor bump; not for internal groundwork nobody can call yet |
| `fix` | a defect corrected | drives the patch bump; **implies you ran the gate that proves it** |
| `refactor` | restructuring with **no** behaviour change | if behaviour changed at all, it is `feat` or `fix`, and calling it a refactor hides that from the log |
| `perf` | a measured improvement | without a number you cannot back the claim — say what you measured, or use `refactor` |
| `docs` | documentation and comments only | includes the spec and the README; not code with a doc comment attached |
| `test` | tests only, added or corrected | a test written alongside the feature ships inside the `feat`, not beside it |
| `build` | build system, dependencies, packaging | dependency bumps live here, not in `chore` |
| `ci` | pipeline config and workflows | |
| `style` | whitespace, formatting, semicolons — **no** meaning changed | **not UI styling.** A CSS change someone can see is `feat` or `fix` |
| `revert` | undoing a previous commit | keep the SHA git puts in the body |
| `chore` | genuinely nothing else fits | the drain everything flows into. Before using it, check whether `build`, `ci`, `docs`, `test`, or `style` applies — one of them usually does |

The enum is the one `@commitlint/config-conventional` ships, so a repo that adds commitlint later validates clean. Do not invent a type: `wip:`, `hotfix:`, `update:`, and `misc:` are all outside it, and the first two describe a workflow state rather than a change.

### Case: lowercase, no trailing period

```
feat(auth): add silent token refresh before expiry
fix(cart): stop double-charging when the retry lands after the timeout
refactor: collapse the three list variants into one component
chore: drop the unused feature-flag helper
```

Lowercase after the colon, always. Both enforcers agree: commitlint's `subject-case` rule rejects sentence-case, start-case, pascal-case and upper-case outright, and Angular's guidelines say "don't capitalize the first letter" and "no dot (.) at the end".

Git's own tradition capitalizes the subject, and that tradition is not wrong — it just predates the type prefix and assumes the subject starts the line. Once you take the prefix you have taken this convention, and mixing the two gives you a log where half the entries shout. Pick lowercase and the log reads as one voice.

**Proper nouns keep their capitals.** `fix: handle Safari's date parsing`, not `safari's`. The rule is about sentence case, not about deleting capitals that carry meaning.

### Mood, length, and what a description says

**Imperative mood.** "add", not "added" or "adds". The test git itself uses: *if applied, this commit will* ___. It is not a stylistic preference — it makes the subject read correctly in `git revert`, `git cherry-pick`, and every changelog generated from the log.

**Under 72 characters** for the whole header. Commitlint's hard default is 100; anything past 72 gets truncated in `git log --oneline`, PR lists, and blame views, which is every place the subject is actually read.

**Say what changed, not what you did.** The author and the process are already recorded.

| Not this | This |
|---|---|
| `fix: address review comments` | `fix(api): reject a negative page size` |
| `chore: as requested` | `refactor: extract the retry policy from the client` |
| `fix: actually fix it this time` | `fix(cart): clear the stale total after a failed retry` |
| `feat: wip` | *not a commit yet — see below* |
| `fix: update Handler.java` | `fix(upload): close the stream when parsing fails` |

The last pair is the common one: the file changed is visible in the diff, so a subject naming the file spends its only line saying nothing.

**No emoji**, unless the repo has already adopted gitmoji and the profile says so. Mixing the two conventions gives you a log that is grep-hostile in two ways at once.

**Work-in-progress commits are fine locally and never reach the trunk.** Use `git commit --fixup <sha>` and `git rebase --autosquash`, or squash on merge. A `wip` in the permanent history is a commit nobody can revert because nobody knows what it contains.

### Attribution

**Commit messages carry no agent attribution. No exceptions, no `Co-Authored-By` for a model or a tool, no "generated with" line, no session URL.**

Three reasons, and the third is the one that matters:

1. `Co-authored-by:` is a trailer git and the forges read as *a person who wrote part of this*. It resolves against an account, lands in the contributor graph and `git shortlog`, and counts toward attribution that is meant to describe people.
2. It is noise on every line of a log that exists to be skimmed, and it scales with the number of commits rather than with the amount of help.
3. **You ran it, you reviewed it, you shipped it.** A harness is a tool, and tools do not co-author. The person who pressed the key is accountable for what landed, and attribution that splits accountability across a tool quietly makes it nobody's.

Keep `Co-authored-by:` for its real purpose: **actual humans who worked on the change.** A pairing partner, someone whose patch you carried, the colleague who found the fix. One trailer per person, `Name <email>` matching their forge account, or it silently fails to link.

**A harness default is not a house rule.** Harnesses inject attribution trailers automatically, and that injected instruction does not override this section — only a rule written down in this repo's house-rules file does. If a repo genuinely wants tool attribution, it says so there, in its own words, and that wins as everything in the house rules wins. Silence is not consent.

---

## Adhere: branch names

```
<type>/<TICKET-ID>-<slug>
```

```
feat/ENG-412-silent-token-refresh
fix/ENG-419-cart-double-charge
refactor/no-ticket-collapse-list-variants
```

- **Same type vocabulary as the commit**, so the branch announces the semver consequence before anyone opens it.
- **The ticket id comes second**, because that is what the tracker matches on. Linear, Jira, and GitHub all auto-link a branch whose name contains the identifier, and that link is free the moment you name the branch and expensive to add later by hand. No ticket, no problem — say `no-ticket` explicitly rather than dropping the field, so the omission reads as deliberate.
- **The slug is the spec's slug**, verbatim, when a spec exists. This is the index: `ls docs/specs/`, `git branch --list '*<slug>*'`, and `ls docs/reviews/` all find the same work with no tooling.
- **Lowercase, hyphens, ASCII.** Not a preference: on macOS and Windows the filesystem is case-insensitive, so `Feat/ENG-412` and `feat/ENG-412` collide as refs and the second fetch fails in a way that reads as a git bug. The ticket id is the one place uppercase is fine, since it is uppercase in the tracker.
- **Under about 60 characters.** It appears in every PR view, every CI status, and every prompt.
- **Exactly two levels.** `feat/ENG-412-thing`, never a bare `feat` and never `feat/eng-412/thing`. Git stores refs as paths, so a branch named `feat` makes `feat/anything` impossible to create until it is deleted, and the error it produces names neither cause nor cure.

`git check-ref-format` rejects the rest, and it is worth knowing which because the failure is opaque: no space, `~`, `^`, `:`, `?`, `*`, `[`, `\`, no ASCII control characters, no `..`, no `@{`, no leading or trailing `/`, no double `//`, no component starting with `.` or ending `.lock`, no trailing `.`. Check a generated name with `git check-ref-format --branch <name>` before creating it.

Delete the branch after the merge. A trunk with four hundred merged branches has no index, only sediment.

---

## Squash merges: the PR title is the commit message

When the repo squash-merges — which the profile names, and which most do — the PR title becomes the subject line of the only commit that reaches the trunk. Every rule above applies to it, and it is the most commonly missed application of them, because a PR title feels like a label rather than permanent history.

Two consequences worth stating:

- **Title the PR in the convention from the start**, not at merge time, when the person clicking the button is often not the person who wrote the change.
- **The squashed body is generated from the commit list**, so local WIP subjects end up in the trunk's history anyway. Clean them up before the merge, or accept that they are permanent.

If the repo merge-commits or rebases instead, every individual commit lands, so every individual commit has to stand on its own.

---

## Validate: reviewing a branch or PR

1. Read the log: `git log --oneline <default-branch>..HEAD`, and the branch name.
2. **Check each subject against its own diff.** This is the only check that requires the diff, and it is the one that catches the top rung. A `refactor:` that changed behaviour and a `fix:` that fixed nothing both parse perfectly.
3. Grade by **the ladder**, worst first.
4. Report the finding and the corrected line, since a message finding has exactly one fix and withholding it wastes a round trip.
5. If the log is clean, say so. There is no formatter here to defer to, but there is a floor: do not manufacture findings out of wording.

### Smells to flag

- An agent, tool, or session as a `Co-Authored-By` or a generator line.
- A type chained onto another type, or a type outside the enum (`wip:`, `hotfix:`, `update:`).
- A ticket id before the type, or used as the scope. Both break something; neither buys anything.
- `chore:` on something that is plainly `build`, `ci`, `docs`, `test`, or `style`.
- `refactor:` on a diff that changed a conditional, a default, or an error path.
- `style:` on a CSS or layout change someone can see.
- `fix:` with no evidence the gate that proves it was run.
- A removed public export, a renamed field, or a changed default with no `!` and no `BREAKING CHANGE:` footer.
- A subject that names the file or the author's process rather than the change.
- Past tense, a capital after the colon, a trailing period, a header past 72 characters.
- A commit whose diff spans two unrelated concerns — the tell is "and" in the subject, or a scope that had to be omitted because several applied.
- A branch with no ticket id and no `no-ticket`, or a slug matching no spec when a spec exists.
- A PR title in prose on a repo that squash-merges.
- A body restating what the ticket or the spec already says.

---

## Guardrails

- **The house rules override any rule here**, including the type enum, the branch form, and the case convention. A repo with an established log has a convention already; match it and say nothing. Consistency with what is there beats this skill.
- **The attribution rule is the exception, and it is only an exception to harness defaults**, never to the house rules. An instruction injected by a tool does not override this; a rule written in this repo's house-rules file does.
- **Never rewrite published history.** Amend, squash, and rebase only what has not been pushed. A tidy log is worth less than a colleague's working checkout.
- **Do not commit unless asked**, and never commit unrelated work alongside the change. Stage deliberately: `git add <paths>`, not `git add -A`.
- **Do not reword old commits to satisfy this skill.** The history is the history, and a rebase that touches fifty messages to fix their capitalization is a worse change than the capitalization.
