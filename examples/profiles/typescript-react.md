# Repo profile

*Worked example: a Next.js web app with a typed API layer and a design system. Copy the shape, not the contents.*

**Stack**: TypeScript 5.7, React 19, Next.js 15 App Router, TanStack Query, Tailwind, Playwright
**Authority**: `CLAUDE.md` wins on any conflict
**Default branch**: `main`

## Paths

| What | Where |
|---|---|
| Specs | `docs/specs/` |
| Reviews | `docs/reviews/` |
| Generated code (never hand-edited) | `src/lib/api/generated/` |
| House rules | `CLAUDE.md` |
| Tickets | GitHub Issues on this repo |
| Ticket prefix | `none`, issues are numbered |
| Tone guide for customer-facing copy | `docs/tone.md` |

## Gates: run these and report the real output

| Gate | Command | When |
|---|---|---|
| types | `npm run typecheck` | always |
| lint | `npm run lint` | always |
| format | `npm run format:check` | always |
| unit tests | `npm test` | always |
| build | `npm run build` | when touching config, middleware, or a route boundary |
| e2e | `npm run test:e2e` | `manual`, needs a seeded database, so report as unverified |
| generated in sync | `npm run api:generate` then `git diff --stat src/lib/api/generated` must be clean | when the API schema changed |

## Lenses

| Lens | Skill | Primary for |
|---|---|---|
| work definition | `ticket-writing` | before any spec, whenever work is being defined |
| spec discipline | `spec-driven-development` | always, first |
| language idiom | `effective-typescript` | any `.ts`/`.tsx` diff |
| framework | `react-next` | components, hooks, routes, server actions |
| structure | `clean-code` | always |
| security | `security-expert` | auth, server actions, anything reading user input |
| change naming | `commit-conventions` | every commit, branch, and PR title |

## Commit conventions

| What | This repo |
|---|---|
| Scopes | the workspace package: `web`, `ui`, `api-client`, `config`. Omit it for a change spanning several |
| Extra types | none |
| Branch form | `<type>/<ENG-nnn>-<slug>` |
| Ticket id in the commit | `(ENG-nnn)` at the end of the description — on despite the squash, because semantic-release publishes a CHANGELOG read by people who cannot click through to a branch. Linear needs a magic word to link, so a commit meant to *close* its issue uses a `Fixes ENG-nnn` trailer instead |
| Trunk merge | squash, so the PR title *is* the commit message |
| Release automation | semantic-release on `main`, so `feat` is a minor and `fix` is a patch. A wrong type ships a wrong version |

## Ladder overrides

- **Server/client boundary mistakes are promoted to rung 2**, level with security, because they are frequently the same finding. A secret imported into a client component ships to the browser, and the type system will not stop you.
- **Effects that leak or cascade** slot in at rung 3, ahead of general resource discipline. They are this stack's version of that rung.

## Spec-worthy here

- A new route, or a change to the route group structure.
- A new server action, or one that gains a side effect.
- Auth, session, or role handling.
- Anything stored in a cookie, in `localStorage`, or in the query cache across navigations.
- A change to the API schema, or a new endpoint consumed.
- A new dependency that ships to the client bundle.
- A design-system component gaining a variant.

**Not spec-worthy**: copy changes, styling within an existing design, dependency bumps, a single-component bugfix, test-only changes, regenerating the API client.

## Hazards: what actually bites in this codebase

- **`"use client"` creeping upward.** One client component imported by a layout turns the whole subtree client-side. Check what a new `"use client"` actually pulls in, not just the file it sits on.
- **Secrets reachable from client code.** Any env var without the public prefix that is imported, even transitively, from a client component. The build will not fail; the value simply ships.
- **Server data copied into `useState`.** The single most common source of "the page shows stale data after mutation". Server state belongs to the query cache.
- **Effects with no cleanup**, especially subscriptions and timers in components that remount on navigation.
- **`any` and `as` at the API boundary.** The generated client is honest; hand-written casts around it are where runtime shape mismatches enter and then surface three components away.

## Definition of done

- The spec's `Date` is bumped in the same PR as the code it describes.
- Any new user-facing state has a designed loading, empty, and error case, and the error case has a way out.
- Anything touching the bundle reports the size delta.

## Escalate elsewhere

- Authorization findings belong in the API repo's tracker. Hiding a control in the UI is not a fix, and a client-side check is never the last line.

## Cannot be verified from here

- Real-device behaviour on slow networks and older browsers.
- Anything behind the e2e suite's seeded database.
- Lighthouse and Core Web Vitals against production data volumes.
