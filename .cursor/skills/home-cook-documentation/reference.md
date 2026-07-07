# Documentation Path Reference — The Home Cook

Quick path map for the documentation skill. Prefer linking to these paths over duplicating content.

## Repository Layout (documentation)

```
/
├── README.md
├── START_HERE/
│   ├── START_HERE.md
│   ├── Product_Specification.md      # authoritative — what
│   └── System_Architecture.md        # authoritative — how
└── docs/
    ├── README.md
    ├── architecture/
    │   ├── Persistence.md
    │   ├── Database.md
    │   ├── AI_Guidelines.md
    │   ├── Development_Standards.md
    │   ├── Roadmap.md
    │   └── Decision_Log.md
    ├── design/
    │   └── README.md
    ├── planning/
    │   ├── documentation_backlog.md
    │   ├── ci-cd-pipeline.md
    │   └── features/
    ├── references/
    │   └── _TEMPLATE.md
    └── reports/
        └── documentation_reorganization_report.md
```

## Folder Rules

| Folder | Put here | Do not put here |
| :--- | :--- | :--- |
| `START_HERE/` | Foundational SRS and architecture | Temporary notes, lab reports |
| `docs/architecture/` | Support docs for persistence, DB, standards, AI, roadmap, decisions | Product requirements, wireframes |
| `docs/design/` | UI, brand, visual planning | Business rules, schema |
| `docs/planning/` | Backlog, stories, lab docs, WIP notes | Authoritative requirements |
| `docs/references/` | Templates, teacher examples, research | Final project policy |
| `docs/reports/` | Reorganization/cleanup/task reports | Living specifications |

## Link Patterns

From `docs/architecture/` to foundational docs:

```markdown
[Product_Specification.md](../../START_HERE/Product_Specification.md)
[System_Architecture.md](../../START_HERE/System_Architecture.md)
```

From `docs/planning/` to foundational docs:

```markdown
[Product_Specification.md](../../START_HERE/Product_Specification.md)
```

From `docs/reports/` to planning docs:

```markdown
[documentation_backlog.md](../planning/documentation_backlog.md)
```

## Status Header Templates

**Draft:**

```markdown
> **Status:** Draft — pending human review.
>
> This document was generated as a starting point. It is not authoritative until reviewed and approved.
```

**Placeholder:**

```markdown
> **Status:** Placeholder — not yet written.
>
> This document will describe [intended purpose].
```

**Planning (backlog-style):**

```markdown
> [!NOTE]
> This file tracks [topic]. It is a planning document, not an authoritative product or architecture document.
```

## Uncertainty Markers

```markdown
> **TODO:** [specific missing work]

> **Decision Needed:** [specific question for human reviewer]
```

## Known Preservation Rules

- Keep `docs/references/_TEMPLATE.md` as a teacher-provided reference
- Do not treat AI output as approved without explicit user confirmation
- Legacy `node_modules/` and `dist/` were removed (Vite/React artifacts) — do not reintroduce in documentation as active project paths
