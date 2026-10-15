---
name: mermaid-diagrams
description: >-
  Design and validate clear, syntactically reliable Mermaid diagrams in specs, design docs,
  architecture overviews, and tickets. Use when visual communication clarifies architecture, state
  transitions, data flow, sequence interactions, or user journeys. Calibrates diagrams to the
  intended audience: high-level conceptual flows for readers outside engineering (Part 1 specs), and
  concrete sequence/state/class diagrams with explicit failure boundaries for engineers (Part 2
  specs). Triggers on "diagram this", "draw a mermaid diagram", "visualize the architecture",
  "flowchart", "sequence diagram", or when a technical explanation in a plan or spec is too dense to
  parse from text alone.
---

# Mermaid Diagrams

Two modes. **Adhere** while planning, specifying, or documenting. **Validate** when reviewing a spec or document containing diagrams.

This skill is the rubric for **visual communication and diagram syntax**. `spec-driven-development` owns the specification structure and the Part 1/Part 2 split; `clean-code` owns architectural layering and separation of concerns. This skill governs translating those structures and sequences into legible, syntactically reliable Mermaid diagrams. The house rules in `.agents/profile.md` **win on any conflict**.

`references/canon.md` carries primary sources, the grammar specification, and syntax traps to avoid.

---

## The ladder, ranked

When findings compete, this is the order that matters:

1. **Syntax error or unrenderable diagram.** Malformed Mermaid code that fails to parse in standard markdown renderers (e.g., unquoted parentheses/brackets in node labels, reserved words used as node IDs). A broken diagram renders an error block and destroys document readability. Nothing outranks this.
2. **Misleading or false system invariant.** Depicting a connection, dependency, trust boundary, or sequence flow that contradicts how the system works (e.g., showing a client directly mutating a database and bypassing the API gateway, or claiming an asynchronous operation is synchronous).
3. **Wrong level of abstraction for the audience.** Inserting low-level implementation details (database columns, thread locks, internal helper functions) into overviews for non-technical readers (Part 1 specs), or providing vague, hand-wavy boxes without protocols, contracts, or failure paths to engineers (Part 2 specs).
4. **Diagram sprawl and visual clutter.** Sprawling diagrams with 20+ nodes, tangled crossing edges, or deeply nested subgraphs that cannot be understood at a glance. A diagram that requires zooming and panning to decipher defeats the purpose of visual communication.
5. **Missing unhappy or failure paths.** Showing only the happy path in sequence or state diagrams while omitting error states, network disconnects, timeouts, authentication rejections, or rollback flows.
6. **Ambiguous labeling.** Unlabeled decision branches (e.g., arrows leaving a diamond without `Yes`/`No` or condition guards), cryptic abbreviations as node labels, or missing actor roles in sequence lifelines.
7. **Cosmetic styling.** Node color themes, font preferences, or layout direction tweaks when the existing diagram is already clear. Not a finding; default renderer styling governs.

---

## Adhere: guide while planning and specifying

### 1. Earn the diagram

**A diagram must clarify, not decorate.** Do not include a diagram if one or two plain sentences convey the same information with less maintenance overhead.

Use a diagram when:
- Multiple services, clients, and datastores interact across boundaries.
- The order of operations in an asynchronous or multi-step flow is hard to follow in prose.
- State transitions have strict conditions, loops, or terminal states.
- A multi-surface feature needs a conceptual map for readers outside engineering.

### 2. Calibrate to the audience

Match the diagram type and abstraction level to who reads the section:

| Audience | Spec Location | Recommended Types | What to include | What to omit |
|---|---|---|---|---|
| **Product, Support, Leadership** | Part 1: What's changing & why | `flowchart LR`, simple state flows, user journey maps | User actions, visible outcomes, key milestone stages | Network protocols, internal table names, schemas, thread details |
| **Engineers, Reviewers, Operators** | Part 2: Technical design | `sequenceDiagram`, `stateDiagram-v2`, `flowchart TD` with `subgraph`, `erDiagram` | Protocol boundaries (`HTTPS`, `gRPC`), error branches, fallback handling, state guards | Generic hand-wavy arrows, marketing terms |

### 3. Syntax rules

To ensure diagrams render reliably across GitHub, IDEs, and CLI tools:

- **Always quote node labels containing punctuation or spaces.**
  ```mermaid
  %% Correct:
  nodeA["API Gateway (/v1/checkout)"]
  nodeB["Local Cache [IndexedDB]"]
  ```
- **Avoid reserved keyword collisions.**
  Do not name node IDs `end`, `subgraph`, `graph`, `default`, or `style`. Use descriptive IDs like `stepEnd["End"]` or `serviceAuth["Auth Service"]`.
- **Always label decision branches in flowcharts.**
  Every branch leaving a diamond decision shape (`{...}`) must state the condition:
  ```mermaid
  flowchart TD
      check{"Token valid?"} -->|Yes| allow["Proceed to resource"]
      check -->|No| refresh["Refresh session"]
  ```
- **Structure sequence diagrams with clear participants and explicit lifelines.**
  Declare actors and participants explicitly at the top. Use `alt`/`else` for branching and `-->>` for return responses:
  ```mermaid
  sequenceDiagram
      actor User
      participant Client as Web App
      participant API as API Server
      participant DB as Database

      User->>Client: Click "Submit Order"
      Client->>API: POST /orders
      API->>DB: Save order record
      alt Success
          DB-->>API: OrderCreated(id)
          API-->>Client: 201 Created
          Client-->>User: Show confirmation
      else Out of stock
          DB-->>API: InventoryError
          API-->>Client: 409 Conflict
          Client-->>User: Show "Item unavailable" notice
      end
  ```
- **Use `stateDiagram-v2` for state machines.**
  Always use `[*]` for initial and terminal states, and label transitions with triggers:
  ```mermaid
  stateDiagram-v2
      [*] --> Draft: Create
      Draft --> Scheduled: Schedule [Valid publish time]
      Draft --> Published: Publish now
      Scheduled --> Published: Publish job triggers
      Published --> [*]: Archive
  ```

---

## Validate: reviewing diagrams

Produce **findings, not a redraw**.

1. Read the document **and** inspect every diagram block.
2. Walk **Adhere** against each diagram, checking syntax and abstraction level.
3. Grade by **the ladder**, worst first.
4. Report only real, actionable findings. Skip cosmetic styling choices.
5. Each finding: `file:line`, the rule, why it bites in concrete terms, the specific fix.
6. If the diagrams are sound, say so, and do not manufacture findings.

### Smells to flag

- Unquoted special characters in node labels: `()`, `[]`, `{}`, `<>`, `"`, `/`.
- Reserved keywords used as node IDs (`end`, `subgraph`, `graph`, `style`, `class`, `default`).
- A diagram showing an assumed endpoint or state transition that contradicts existing code or contracts.
- Low-level implementation details (database tables, thread locks) in Part 1.
- Missing failure, timeout, or error branches in a Part 2 sequence or state diagram.
- More than 15–20 nodes or tangled link crossings in a single diagram where two smaller diagrams would be clearer.
- Unlabeled decision branches leaving a flowchart diamond.

---

## Guardrails

- **Fenced code blocks only.** Diagrams must be native ````mermaid``` code blocks in markdown. Never link to externally hosted images or generate static raster images.
- **The text remains the authority.** A diagram is an illustrative aid; the written specification holds the contract. If a diagram and the accompanying text disagree, resolve the contradiction in the text first.
- **Limit diagram count.** Most specs need at most one or two diagrams (e.g., a conceptual flow in Part 1 and a sequence diagram in Part 2). More than three diagrams in a single spec is usually a sign of over-specification or a spec that needs to be split.
