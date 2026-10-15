# Repo profile

*Worked example: a Go microservice in a monorepo, gRPC in front, Postgres behind, multi-tenant. Copy the shape, not the contents.*

**Stack**: Go 1.25, gRPC/Connect, sqlx over Postgres, dbmate migrations, generated proto clients
**Authority**: `AGENTS.md` wins on any conflict
**Default branch**: `main`

## Paths

| What | Where |
|---|---|
| Specs | `docs/specs/` |
| Reviews | `docs/reviews/` |
| Generated code (never hand-edited) | `proto/gen/`, `internal/enums/` |
| House rules | `AGENTS.md` |
| Tickets | Linear, team ENG |
| Ticket prefix | `ENG-` |

## Gates: run these and report the real output

| Gate | Command | When |
|---|---|---|
| build | `go build ./...` | always |
| vet | `go vet ./...` | always |
| lint | `golangci-lint run` | always |
| test | `go test ./...` | always |
| race | `go test -race ./internal/worker/...` | when touching goroutines or shared state |
| generated in sync | `buf generate` then `git diff --stat proto/gen` must be clean | when a `.proto` changed |
| migrations | `dbmate up && dbmate rollback && dbmate up` | when a migration is added |

## Lenses

| Lens | Skill | Primary for |
|---|---|---|
| work definition | `ticket-writing` | before any spec, whenever work is being defined |
| spec discipline | `spec-driven-development` | always, first |
| language idiom | `effective-go` | any `.go` diff |
| structure | `clean-code` | always |
| security | `security-expert` | any handler, query, or auth change |
| change naming | `commit-conventions` | every commit, branch, and PR title |

## Commit conventions

| What | This repo |
|---|---|
| Scopes | `api`, `db`, `auth`, `billing`, `worker`, `deploy` — nothing else; add one by editing this row |
| Extra types | none |
| Branch form | `<type>/<ENG-nnn>-<slug>` |
| Ticket id in the commit | off — the branch carries it, and we squash, so it reaches the trunk anyway |
| Trunk merge | squash, so the PR title *is* the commit message |
| Release automation | none — the changelog is written by hand at each tag, from `git log --oneline` |

## Ladder overrides

- **Tenant isolation is promoted to rung 1**, above general correctness. A query missing its tenant predicate is a cross-customer data breach rather than a bug, and it is the failure this codebase is most able to ship without noticing.
- **Context propagation is promoted above error handling.** A dropped `context.Context` turns a cancelled request into work that runs forever, and we have taken production down that way twice.

## Spec-worthy here

- A `.proto` change of any kind, including adding a field.
- A database migration.
- A new event type, or a change to what an existing event carries.
- A cross-module dependency: module A importing module B for the first time.
- Auth, session, tenancy, or permission handling.
- A new external service call, including a third party.
- Anything that changes what a background worker does.

**Not spec-worthy**: copy fixes, dependency bumps, a single-file localized bugfix, test-only changes, regenerating `proto/gen`, adding a config value an existing spec already called for.

## Hazards: what actually bites in this codebase

- **Every query must be filtered by `tenant_id`, and the value comes from the authenticated session rather than the request.** A missing predicate is a cross-tenant leak. Repositories are the layer that enforces it; a handler building its own SQL is a finding on its own.
- **Goroutines started per request must take the request context and must not outlive it.** `go doThing()` with no context and no waitgroup is the most common serious review finding here.
- **Errors get wrapped once, with `%w`, at the layer that adds information.** Wrapping at every level produces messages nobody can read; swallowing produces incidents nobody can debug.
- **`sql.ErrNoRows` is a domain outcome, not a failure.** Returning it raw to a handler turns "this user has no avatar" into a 500.
- **The cache and Postgres disagree after a partial failure.** Any write path that touches both needs its ordering justified in the diff.

## Definition of done

- The spec's `Date` is bumped in the same PR as the code it describes.
- A migration has been rolled back and reapplied locally, and the rollback is in the same PR.
- Anything touching the worker pool has run under `-race`.

## Escalate elsewhere

- Findings about the mobile or web clients go in their own repo's tracker. Never work around a client bug by loosening a server-side check.
- Infrastructure and Helm values live in the infra repo; a config finding there is a ticket, not a patch here.

## Cannot be verified from here

- Production query plans and index usage at real table sizes.
- Anything requiring the payment provider's sandbox credentials.
- Behaviour under real concurrent load; `-race` catches data races, not contention.
