# Go canon: fetch, don't recall

The rules in `SKILL.md` are summaries. When a rule is disputed, when a version boundary matters, or when a persona is about to assert how a standard-library API behaves, **fetch the source and quote it.**

## Versioned documentation

This repo pins the Go version in `go.mod`. Read the package documentation for **that version**, since the standard library gains APIs every release and reviewers routinely recommend ones the pinned toolchain does not have.

- Standard library reference: <https://pkg.go.dev/std>
- Release notes, all versions: <https://go.dev/doc/devel/release>

`errors.Join`, `slices`, `maps`, `log/slog`, `sync.OnceFunc`, and range-over-func each landed in a specific release. Check `go.mod` before recommending them.

## Primary sources

| Source | Use for | URL |
|---|---|---|
| Effective Go | The baseline idiom, still the reference for naming and structure | <https://go.dev/doc/effective_go> |
| Go Code Review Comments | The canonical review checklist, and the thing to quote in a disagreement | <https://go.dev/wiki/CodeReviewComments> |
| The Go Memory Model | Settles any argument about what is and is not a data race | <https://go.dev/ref/mem> |
| Go Proverbs | Short, quotable, and usually the fastest way to end a design debate | <https://go-proverbs.github.io/> |
| The Go Blog on errors | `%w`, `errors.Is`, `errors.As`, and when each applies | <https://go.dev/blog/go1.13-errors> |
| The Go Blog on context | Propagation and cancellation, from the authors | <https://go.dev/blog/context> |
| The Go Blog on slices | The aliasing and `append` behaviour behind rung 6 | <https://go.dev/blog/slices-intro> |
| The Go Spec | The last word on nil interfaces, method sets, and evaluation order | <https://go.dev/ref/spec> |

## Tooling

| Tool | Use for | URL |
|---|---|---|
| `go vet` | The checks the compiler will not make | <https://pkg.go.dev/cmd/vet> |
| Race detector | Confirming a suspected race, on paths a test exercises | <https://go.dev/doc/articles/race_detector> |
| golangci-lint | The linter set this repo runs; check `.golangci.yml` for what is enabled | <https://golangci-lint.run/> |
| staticcheck | The check IDs (`SA1019` and friends) worth citing by number | <https://staticcheck.dev/docs/checks> |

## How to use this file

1. **Before asserting a standard-library API exists**, check `go.mod` and the release notes.
2. **Before calling something unidiomatic**, find it in Effective Go or Code Review Comments and quote the line. If neither settles it, say so plainly, give a recommendation with its reasoning, and label it a judgement call.
3. **Before claiming a data race**, check the memory model rather than intuition, and name the two goroutines and the shared value.
4. **Prefer the repo's house rules** over anything here when they conflict. A local convention beats a general best practice.
