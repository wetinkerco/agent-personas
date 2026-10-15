# <Skill> canon: fetch, don't recall

<!--
  SCAFFOLD. Delete every comment block before committing. Delete this whole file if the skill
  has no primary sources worth fetching.

  This file exists because model recall of fast-moving ecosystems is confidently wrong at exactly
  the version boundaries that matter. Its job is to turn "I think it works like this" into a
  fetch, and to let a persona settle a dispute by quoting the rule rather than winning on tone.

  Include a source when it is AUTHORITATIVE and FETCHABLE. Blog posts and conference talks are
  neither, so leave them out however good they were.
-->

The rules in `SKILL.md` are summaries. When a rule is disputed, when a version boundary matters, or when a persona is about to assert how an API behaves, **fetch the source and quote it.**

## Versioned documentation

<!--
  The single most valuable entry. Pin the URL to the version this repo actually uses, and say
  where to find that version, so the link can be corrected rather than silently rotting.
-->

This repo pins `<thing>` **<version>**. See `<the manifest file>`. Read the documentation for **that version**:

- <https://...>

Remembered advice about `<ecosystem>` is frequently one or more major versions stale. Check the manifest before asserting how anything behaves.

## Primary sources

| Source | Use for | URL |
|---|---|---|
| <The language or framework's own reference> | <the question it settles> | <https://...> |
| <The style guide the community actually follows> | <...> | <https://...> |
| <The specification, where one exists> | <...> | <https://...> |

## Release notes and migration guides

<!--
  Where "this changed in v5" questions get settled. Worth its own section because it is the
  fastest way to catch advice that was correct two versions ago.
-->

- <https://...>

## How to use this file

1. **Before asserting how an API behaves**, read the versioned docs for the pinned version.
2. **Before calling something unidiomatic**, find the rule in a primary source and quote it. If the canon does not settle it, say so plainly, give a recommendation with its reasoning, and label it a judgement call.
3. **Prefer the repo's house rules** over anything here when they conflict. A local convention beats a general best practice.
