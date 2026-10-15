# Commit and branch canon: fetch, don't recall

Unlike most canon, this one barely moves — Conventional Commits has been at 1.0.0 since 2019 and git's ref rules are older than that. What moves is the **enforcement**: a repo's commitlint config, its release tooling, and the type enum they share. Read those from the repo before citing a rule at someone.

Cite the specific rule, not "the convention says".

## The standard

| Source | Use for | URL |
|---|---|---|
| Conventional Commits 1.0.0 | The grammar: type, scope, `!`, description, body, footers. The authority on what is and is not valid | https://www.conventionalcommits.org/en/v1.0.0/ |
| `@commitlint/config-conventional` | The **enforceable** form of it: the type enum, `subject-case`, `subject-full-stop`, `header-max-length` | https://github.com/conventional-changelog/commitlint/blob/master/%40commitlint/config-conventional/src/index.ts |
| Angular commit message guidelines | Where the type vocabulary originated, and the source of "don't capitalize", "no dot at the end", imperative mood | https://github.com/angular/angular/blob/main/contributing-docs/commit-message-guidelines.md |

The rules this skill leans on, so they can be checked without a fetch:

- **`type-enum`**: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`
- **`type-case`**: lower-case · **`type-empty`**: never · **`subject-empty`**: never
- **`subject-case`**: never sentence-case, start-case, pascal-case, or upper-case
- **`subject-full-stop`**: never `.` · **`header-max-length`**: 100 · **`header-trim`**: always
- **`body-leading-blank`** and **`footer-leading-blank`**: always

## Git itself

| Source | Use for | URL |
|---|---|---|
| `git check-ref-format` | What is legal in a branch name. Run `git check-ref-format --branch <name>` rather than reasoning about it | https://git-scm.com/docs/git-check-ref-format |
| `git commit` | Trailer handling, `--fixup`, `--amend` | https://git-scm.com/docs/git-commit |
| `git interpret-trailers` | The trailer grammar, which is what makes `Refs:` and `Co-authored-by:` machine-readable rather than decorative | https://git-scm.com/docs/git-interpret-trailers |
| Git SubmittingPatches | The imperative-mood rule, from the project that invented the format | https://github.com/git/git/blob/master/Documentation/SubmittingPatches |

## Forges and tooling

| Source | Use for | URL |
|---|---|---|
| GitHub: creating a commit with multiple authors | The `Co-authored-by:` trailer — its exact form, and what it takes for the forge to link it to a person | https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors |
| GitHub: linking a pull request to an issue | The closing keywords a footer can use, and which ones actually close | https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue |
| Jira Smart Commits | Where the issue key may sit in a message, and the command syntax after it | https://support.atlassian.com/jira-software-cloud/docs/process-issues-with-smart-commits/ |
| Linear: GitHub integration | Its magic words, and why a bare issue id in a commit does not link | https://linear.app/docs/github |
| semantic-release | What a type costs when a release is automated: `feat` → minor, `fix` → patch, `BREAKING CHANGE` → major | https://semantic-release.gitbook.io/semantic-release/ |
| Conventional Commits: the FAQ | The edge cases — multiple types, reverts, a wrong type already pushed | https://www.conventionalcommits.org/en/v1.0.0/#faq |

## How to use this file

1. **Before disputing a type**, check the repo's own commitlint config (`commitlint.config.*`, or `.commitlintrc*`, or the `commitlint` key in `package.json`). A repo that extends the conventional config with its own types has settled the question locally.
2. **Before calling a branch name invalid**, run `git check-ref-format --branch <name>`. It is the authority, it is already installed, and its answer is not arguable.
3. **Before claiming a type has no consequence**, check whether the repo automates releases. With semantic-release or an equivalent in the pipeline, `feat` versus `fix` is a version number rather than a label, and a mislabelled commit ships a wrong one.
4. **Prefer the repo's house rules over everything here.** This file is the general canon; a convention already visible in `git log` is more specific and wins.
