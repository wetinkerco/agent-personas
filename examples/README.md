# Examples

Reference material. The installer does not copy anything from this directory.

## Profiles

Filled-in `.agents/profile.md` files, showing the shape at realistic density:

- [`profiles/go-service.md`](profiles/go-service.md). A Go microservice, gRPC in front, Postgres behind, multi-tenant.
- [`profiles/typescript-react.md`](profiles/typescript-react.md). A Next.js app with a typed API layer, including a `manual` gate that gets reported as unverified.

Read the **Hazards** section in each first. That section is where a generic reviewer turns into a reviewer of your system, and it is the one people leave empty. It should name the failure modes you have actually shipped, not the ones a checklist would list.

Compare the **Ladder overrides** sections. Each promotes a different rung for a stack-specific reason: tenant isolation in Go, the server/client boundary in Next.js. That is the mechanism working as intended, and it is why the universal ladder in the guide is a default rather than a rule.

Neither example turns the spec gate off. For that, see the quote block under **Spec-worthy here** in [`templates/profile.md`](../templates/profile.md): set `Specs: none` and the reviewer skips the gate while the planner returns its plan in a message instead of a file.

Both profiles name stack skills that do not exist in this repo, and that is correct rather than an oversight. A profile describes what a *consuming* repo writes, and a consuming repo's stack skills live in that repo. `effective-typescript` would sit in the Next.js codebase, `effective-go` in the Go one. Only the universal skills travel with the roster.

## Skills

- [`skills/effective-go/`](skills/effective-go/). A worked stack skill, showing what density looks like.

One example, not a matched pair with the profiles above. It is here to demonstrate density, not to complete a set, and there is deliberately no `effective-typescript` beside it: a stack skill written by someone who does not work in that stack is exactly the confident, stale artifact you do not want. Write yours from your own incident history.

Nothing installs this and nothing upgrades it. It exists because [`templates/skill/`](../templates/skill/) teaches the *shape* of a skill and only a real one teaches the *density*.

The thing to study is the ladder. Every rung names a failure that has actually shipped in Go code, in an order set by consequence rather than by how often it comes up. Compare rung 1 with the equivalent line in a style guide:

> **A style guide says:** goroutines should be cleaned up.
>
> **The ladder says:** a goroutine with no owner, no cancellation, and no bounded exit. `go doThing()` fired from a request handler with nothing waiting on it. These leak memory and file descriptors until the process dies, and they never reproduce in a unit test.

The second is checkable and the first is a slogan. Build yours from your incident history and it comes out like the second on its own.
