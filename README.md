# agent-personas

This started with a simple premise: orchestrate coding agents around distinct personas and have fun with it. Instead of one generic assistant doing everything lukewarmly, give each job a character with clear boundaries, real standards, and a license to push back.

The personas take their names from Brooklyn Nine-Nine characters, which does more work than it looks like. [GUIDE.md](GUIDE.md#4-why-a-character) explains why.

## The roster

| Persona      | Role                                                            | Writes          | Edits code? |
| ------------ | --------------------------------------------------------------- | --------------- | ----------- |
| **Santiago** | Plans. Presses on the _why_, scopes, writes the spec            | `docs/specs/`   | no          |
| **Jake**     | Implements. Makes the code idiomatic and proves it              | source          | **yes**     |
| **Holt**     | Reviews. Spec gate, multi-lens review, definition-of-done gates | `docs/reviews/` | no          |

Santiago opens the work and Holt closes it. Exactly one persona touches source, which is what makes the set safe to run with loose permissions: a reviewer that can edit code will quietly fix what it finds and hand you a clean review of its own work.

## Install

Claude Code, as a plugin:

```
/plugin marketplace add wetinkerco/agent-personas
/plugin install precinct@wetinker
```

Any harness, from the root of the target repo:

```bash
curl -fsSL https://raw.githubusercontent.com/wetinkerco/agent-personas/main/install.sh | sh
```

It writes the canonical content to `.agents/`, symlinks a vendor directory at `.claude/`, and stamps a version so `--check` can report drift later. Run it again to upgrade; it keeps files you've edited unless you pass `--force`. Useful flags:

```bash
install.sh --vendor cursor|none          # or skip the vendor directory entirely
install.sh --personas reviewer,planner   # a subset of the roster
install.sh --check                       # what drifted, changing nothing
```

By hand, if you'd rather: copy `personas/`, `commands/`, and `skills/` into `.agents/`, then symlink them into whatever directory your tool reads. Keep the real files in `.agents/` and let every vendor directory hold nothing but links, so each artifact has one source of truth.

```bash
ln -s ../../.agents/personas/reviewer.md .claude/agents/reviewer.md
```

Make the link relative so it survives a clone on someone else's machine.

All three give you the personas, their slash commands, and the six universal skills. None of them gives you a profile, which is the next step and the one that matters.

## Write your profile

This is the only required step, and it's what separates a sharp reviewer from a vague one.

If you used `install.sh`, it already wrote a stub and the template sits beside it:

```bash
$EDITOR .agents/profile.md
```

If you installed the plugin, the template lives in the plugin cache rather than your repo, so pull one down:

```bash
mkdir -p .agents
curl -fsSL https://raw.githubusercontent.com/wetinkerco/agent-personas/main/templates/profile.md -o .agents/profile.md
```

The profile names your gate commands, your lenses, your spec and review directories, what counts as spec-worthy here, and the failure modes that actually bite in this codebase. That last section carries most of the weight. See [`templates/profile.md`](templates/profile.md), and [`examples/profiles/`](examples/profiles/) for filled-in ones.

Without a profile the personas still run. They infer what they can from your build and CI files, say which parts they inferred, and never invent a gate command they haven't confirmed exists. You just get a more generic reviewer.

## Specializing them

The personas specialize entirely through skills. Adding one changes no persona, ever. If you catch yourself editing a persona to teach it about your stack, what you wanted was a skill.

Six ship with the roster because they're true everywhere: `ticket-writing`, `spec-driven-development`, `mermaid-diagrams`, `clean-code`, `security-expert`, and `commit-conventions`. The ones that make a reviewer feel sharp about _your_ stack are yours to write:

```bash
cp -r .agents/templates/skill .agents/skills/effective-<your-language>
```

Then name it in your profile's lens table. [`templates/skill/`](templates/skill/) is a scaffold with the ladder, the two modes, and a canon stub, and [`examples/skills/effective-go/`](examples/skills/effective-go/) is a worked one at realistic density. [GUIDE §9](GUIDE.md#9-anatomy-of-a-skill) covers how to build a ladder that produces findings instead of platitudes, which mostly comes down to building it from your incident history rather than from a style guide.

## What's deliberately absent

Per-language and per-framework skills stay in the repos that use them. `effective-go` belongs to your Go repo and `effective-typescript` to your React one. This repo holds only what's true everywhere, and your profile names the local ones as lenses.

The spec process is optional too. Set `Specs: none` in your profile and the gate disappears. The personas keep pressing on the _why_, because that's a question about the change rather than about your process, but they stop asking for the document.

There's also no orchestrator, no state machine, and no runner. Handoffs between personas are files on disk correlated by a shared slug, and you're the scheduler.

## The guide

[GUIDE.md](GUIDE.md) is the core: the authority chain, persona anatomy, the bookend pattern, the handoff contract, ranked ladders, skill anatomy, harness mapping, and the anti-patterns. Read it before writing a persona of your own.

## License

MIT.
