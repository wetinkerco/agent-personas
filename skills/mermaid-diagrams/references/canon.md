# Mermaid Canon: Primary Sources & Syntax Reference

Mermaid syntax moves, and renderers (GitHub, GitLab, Claude, IDE previewers) vary in which Mermaid version they support. When verifying syntax or recommending constructs, **stick to universal constructs that render across all standard renderers.**

## Primary Sources

| Source | Description | URL |
|---|---|---|
| Mermaid Official Docs | Full reference documentation and grammar rules | <https://mermaid.js.org/> |
| Mermaid Live Editor | Interactive sandbox to test rendering and parse errors | <https://mermaid.live/> |
| Flowcharts Syntax | Nodes, shapes, arrows, subgraphs, link styles | <https://mermaid.js.org/syntax/flowchart.html> |
| Sequence Diagrams | Actors, participants, activations, loops, alts | <https://mermaid.js.org/syntax/sequenceDiagram.html> |
| State Diagrams v2 | State machines, composite states, transitions | <https://mermaid.js.org/syntax/stateDiagram.html> |
| Entity-Relationship | Entities, relationships, cardinalities | <https://mermaid.js.org/syntax/entityRelationshipDiagram.html> |
| Class Diagrams | Types, methods, visibility, relationships | <https://mermaid.js.org/syntax/classDiagram.html> |

---

## High-Risk Syntax Traps

These are the most frequent causes of failed diagram rendering in LLM-generated output:

### 1. Special characters in node labels
Any label containing parentheses `()`, brackets `[]`, braces `{}`, quotes `"`, slashes `/`, or angle brackets `<>` **must be double-quoted inside the node shape definition**:

```mermaid
%% BAD: crashes the parser
node1[Fetch /api/users (v1)]

%% GOOD: safely enclosed
node1["Fetch /api/users (v1)"]
```

### 2. Reserved words as Node IDs
Avoid using keywords as node IDs: `end`, `subgraph`, `graph`, `style`, `class`, `click`, `default`. Instead, use alphanumeric prefixes like `nodeEnd["End"]` or `stepFinish["Complete"]`.

### 3. Flowchart versus Graph declaration
Always declare `flowchart TD` or `flowchart LR` rather than `graph TD`. `flowchart` is the modern engine and supports subgraphs, rich shapes, and proper link routing.

### 4. Sequence diagram arrow semantics
- `->>`: Synchronous message (solid line, filled arrowhead)
- `-->>`: Asynchronous reply / return (dashed line, filled arrowhead)
- `-)`: Asynchronous post / event (solid line, open arrowhead)
- `--)`: Asynchronous response (dashed line, open arrowhead)

### 5. Multi-line labels
Use `<br/>` for line breaks inside quoted strings:
```mermaid
node2["Primary Service<br/>(Reads & Writes)"]
```
Do not insert literal newlines inside the label quotes.
