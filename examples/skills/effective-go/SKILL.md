---
name: effective-go
description: >-
  Dogmatic enforcement of idiomatic Go. Use when writing, refactoring, or reviewing any Go code,
  and always before opening a PR. Covers goroutine lifetimes and concurrency, error handling and
  wrapping, context discipline, the nil and interface traps, resource cleanup, API surface, and
  package layout. Triggers on "review this", "is this idiomatic", "why is this flaky", "why is
  this leaking", or any diff touching a `.go` file. This repo's house rules win on any conflict.
---

# Effective Go

*This is a worked example of a stack skill, not a maintained artifact. It shows what the density of a real one looks like: every rung below is a thing that has actually shipped and broken. Copy the shape, then rebuild the content from your own incident history.*

Two modes. **Adhere** while writing or refactoring. **Validate** when reviewing a diff.

This skill is the rubric for **Go the language and runtime**. `clean-code` is the rubric for structure, and the profile's framework lens covers whatever sits on top. They overlap deliberately, and when they do, prefer the more specific one. The house rules named in `.agents/profile.md` **win on any conflict**.

Go moves slowly, but the standard library does not. Check the version in `go.mod` before asserting that an API exists; `references/canon.md` has the source list.

---

## The ladder, ranked

When findings compete, this is the order that matters.

1. **Goroutine lifetimes.** A goroutine with no owner, no cancellation, and no bounded exit. `go doThing()` fired from a request handler with nothing waiting on it. A worker reading from a channel nobody closes. An unbounded `go` inside a loop over user-supplied input. These leak memory and file descriptors until the process dies, and they never reproduce in a unit test. Nothing outranks them.
2. **Data races and shared state.** A map or slice written from two goroutines. A struct field guarded by a mutex in one method and not another. A `sync.WaitGroup` whose `Add` races its `Wait`. The race detector finds these only on code paths a test actually exercises, so read for them too.
3. **Errors dropped, swallowed, or flattened.** `_ = doThing()`. A `defer f.Close()` on a writer, which discards the error that says the write failed. `fmt.Errorf` without `%w`, which severs `errors.Is` for every caller above. Logging and returning the same error, which produces the same incident three times in the logs.
4. **Context discipline.** A function doing I/O without taking `ctx`. `context.Background()` invented halfway down a call stack, which detaches the work from the request that started it. A context stored in a struct field. A cancel func from `context.WithTimeout` that is not deferred.
5. **The nil traps.** A typed nil pointer returned as an `error` or any interface: the interface is non-nil and every `if err != nil` fires. Writing to a nil map. A nil slice and an empty slice serializing differently in JSON. Calling a method on a nil receiver that dereferences a field.
6. **Resource and aliasing.** A `defer` inside a loop, so nothing releases until the function returns. `rows.Close` missing, or `rows.Err()` never checked after the loop. A subslice retaining the whole backing array. `append` mutating a caller's slice because capacity happened to be spare.
7. **API surface and types.** Exported identifiers that did not need to be. Interfaces declared beside the implementation instead of beside the consumer. A returned interface where a concrete type would do. `interface{}` or `any` where a type parameter or a real type is available.
8. **Naming and comments.** Stutter (`user.UserID`), package names like `util` or `common`, doc comments that do not begin with the identifier, comments explaining what the code already says.
9. **Formatting.** Not a finding. `gofmt` owns it.

---

## Adhere: checklist while writing

### Concurrency

- **Every goroutine has a known exit.** Before writing `go`, answer: what stops this, and who waits for it? If neither answer exists, do not start it.
- **The starter owns the lifetime.** Pass `ctx`, select on `ctx.Done()`, and use `errgroup` when you need the error or the join. A goroutine that outlives its caller needs an explicit owner and a comment saying so.
- **Bound anything driven by input.** A `go` per item over a user-supplied slice is a denial-of-service primitive. Use a semaphore or a worker pool with a fixed size.
- **Channels: the sender closes, never the receiver.** Document direction in the signature (`<-chan T`) so misuse is a compile error.
- **Prefer a mutex to a channel for guarding state.** Channels are for handing off ownership. Use `sync.Mutex` for protecting a field, and keep the critical section small enough to read at a glance.

### Errors

- **Handle or return, never both.** Logging and returning produces duplicate noise and hides the real handler.
- **Wrap once, where you add information.** `fmt.Errorf("loading user %s: %w", id, err)`. Lowercase, no trailing punctuation, no "failed to" prefix, since the caller supplies the context above.
- **Sentinels for expected outcomes, types for structured ones.** `errors.Is` for "does this mean not-found", `errors.As` when the caller needs a field off the error.
- **Translate at the boundary.** `sql.ErrNoRows` is a storage detail. Convert it to a domain error in the repository, not three layers up.
- **`defer` on anything that can fail needs its error captured**, usually through a named return.

### Context

- **`ctx context.Context` is the first parameter** of any function that does I/O, blocks, or spawns. Never a struct field.
- **Propagate, do not invent.** `context.Background()` belongs in `main`, in tests, and in the top of a detached worker that is documented as detached.
- **`defer cancel()` immediately** after `WithCancel`, `WithTimeout`, or `WithDeadline`, every time.
- **Values in context are for request-scoped metadata only**, with an unexported key type. Not for passing dependencies.

### Types and API

- **Accept interfaces, return structs.** Declare the interface in the consuming package, sized to what that consumer calls.
- **Zero values should work.** A struct usable without a constructor is easier to test and impossible to half-initialize.
- **Unexport by default.** Every exported identifier is a promise; make the package explain itself through what it does not show.
- **Small interfaces.** One or two methods. A five-method interface with one implementation is a struct wearing a costume.

### Packages and tests

- **Name packages for what they provide**, as a lowercase noun with no underscores. Never `util`, `common`, `helpers`, `base`, or `misc`.
- **Table-driven tests**, with subtests named for the case. Assert on behaviour rather than on call sequence.
- **`t.Parallel()` deliberately**, and watch for the shared fixture it makes unsafe.
- **Test the error paths.** A test suite that only covers success is why rung 3 keeps happening.

---

## Validate: reviewing a diff

Produce **findings, not a rewrite**.

1. Read the diff **and** the files it touches.
2. Walk **Adhere** against the change, only where it applies.
3. Grade by **the ladder**, worst first.
4. Report only real, actionable findings, and skip anything `gofmt` or the linter already owns.
5. Each finding: `file:line`, the rule, why it bites in concrete terms, the specific fix.
6. If it is clean, say so, and do not manufacture findings.

### Smells to flag

- `go func()` with no `ctx`, no waitgroup, and no comment naming its owner.
- `context.Background()` anywhere below `main` or a test.
- `fmt.Errorf` with `%v` on an error, or a wrapped error re-wrapped at the next level up.
- `_ =` on anything returning an error, and bare `defer f.Close()` on a writer.
- A `defer` inside a `for` body.
- A function returning `(*T, error)` where the nil `*T` is returned as a non-nil interface elsewhere.
- `time.Sleep` used to synchronize anything outside a test.
- A mutex copied by value, usually by a method with a value receiver on a struct that holds one.
- An interface declared in the same file as its only implementation.
- `any` in a signature written after generics were available.
- A package named `util`, `common`, or `helpers`.
- `rows.Err()` unchecked after a `for rows.Next()` loop.

---

## Guardrails

- **The house rules override any rule here.** When this skill says extract and the house rule says inline it, inline it.
- **Do not clean unrelated code during a focused task.** Note it and move on.
- **Do not demand an interface for testability** where a concrete type and a real dependency would do. Go's answer to a hard-to-test function is usually a smaller function.
- **Do not report a race you cannot demonstrate.** Name the two goroutines and the shared value, or label it as a suspicion.
