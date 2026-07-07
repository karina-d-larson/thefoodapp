---
name: home-cook-documentation
description: Draft, revise, and organize markdown documentation for The Home Cook. Use when writing or editing project docs, architecture support documents, planning notes, reports, design materials, START_HERE files, or when the user asks for documentation help, SRS updates, architecture docs, backlog drafting, or doc reorganization guidance.
---

# The Home Cook — Documentation Writing

## When to Use

Apply this skill when:

- Drafting or revising any project markdown documentation
- Creating architecture support documents, planning notes, reports, or design materials
- Migrating content between documentation files
- The user asks for documentation structure, backlog work, or review-ready drafts

Do **not** use this skill to silently rewrite authoritative foundational documents unless the user explicitly requests that work.

## Pre-Flight Checklist

Before writing or editing documentation:

1. Read [START_HERE/START_HERE.md](../../../START_HERE/START_HERE.md) for the documentation map.
2. Read the relevant authoritative source(s):
   - **What / why:** [START_HERE/Product_Specification.md](../../../START_HERE/Product_Specification.md)
   - **How / structure:** [START_HERE/System_Architecture.md](../../../START_HERE/System_Architecture.md)
3. Check [docs/planning/documentation_backlog.md](../../../docs/planning/documentation_backlog.md) if the task relates to planned documentation work.
4. Inspect the target file and nearby related docs to avoid duplication or contradiction.
5. Confirm the correct folder for the document type (see [reference.md](reference.md)).

## Authority Model

| Authority level | Meaning | Examples |
| :--- | :--- | :--- |
| **Authoritative** | Reviewed project truth for its scope | `START_HERE/Product_Specification.md`, `START_HERE/System_Architecture.md` |
| **Support** | Expands on authoritative docs without replacing them | `docs/architecture/*.md` |
| **Planning** | Draft, temporary, or backlog material | `docs/planning/**` |
| **Reference** | Templates and external examples | `docs/references/**` |
| **Report** | Historical record of work performed | `docs/reports/**` |
| **Design** | Visual and UX planning materials | `docs/design/**` |
| **AI draft** | Generated content pending human review | Any new or heavily revised doc until approved |

### Project rules (preserve verbatim intent)

1. `START_HERE/Product_Specification.md` defines **what** the product is intended to accomplish.
2. `START_HERE/System_Architecture.md` defines **how** the system is structured.
3. `START_HERE/START_HERE.md` defines how the documentation system is organized.
4. Supporting documents should complement these files, not contradict or replace them.
5. Higher-level documents define **what** and **why**.
6. Lower-level documents define **how**.
7. Every document should have a single clear responsibility.
8. Generated documentation is **draft content** until reviewed and approved.
9. Uncertain details should be marked clearly instead of silently decided.
10. Major architectural, database, sync, privacy, AI, provider, or dependency decisions must not be invented without human review.

## Documentation Hierarchy

```
README.md                          → short repo entry point
START_HERE/                        → foundational docs (read first)
docs/architecture/                 → how-to implement structure (support)
docs/design/                       → visual / UX materials
docs/planning/                     → backlog, stories, lab notes, temporary work
docs/references/                   → templates and supporting examples
docs/reports/                      → completed task / reorganization reports
```

Full path map: [reference.md](reference.md)

## Document Responsibilities

### Product Specification vs System Architecture

| Question | Answer in |
| :--- | :--- |
| What must the product do? | `Product_Specification.md` |
| What is in or out of scope? | `Product_Specification.md` |
| What quality or data requirements apply? | `Product_Specification.md` |
| How is the system layered and structured? | `System_Architecture.md` |
| Who owns which domain data? | `System_Architecture.md` |
| How do domains and layers interact? | `System_Architecture.md` |
| What persistence or external-service boundaries exist? | `System_Architecture.md` |

**Do not:**

- Put implementation details in the Product Specification
- Put new product requirements in the System Architecture
- Duplicate requirement text in architecture support docs — link or summarize instead

### Architecture support documents (`docs/architecture/`)

Each file has one job:

| File | Responsibility | Should include | Should avoid |
| :--- | :--- | :--- | :--- |
| `Persistence.md` | Storage access, abstractions, offline/sync posture | Principles, boundaries, ownership | Full SQL schema |
| `Database.md` | Logical/physical data model | Entities, relationships, ownership | Business rules in DB layer |
| `Development_Standards.md` | How contributors build the project | Conventions, testing, review | Redefining architecture |
| `AI_Guidelines.md` | Safe AI assistance boundaries | Confirmation, privacy, prohibited automation | Product requirements |
| `Decision_Log.md` | Record of confirmed decisions | Context, alternatives, consequences | Invented or assumed decisions |
| `Roadmap.md` | Sequencing and milestones | Phases, priorities | Committed release promises |

Cross-reference `System_Architecture.md` instead of copying layer or domain sections.

### Planning documents (`docs/planning/`)

- Backlog, feature stories, CI/CD lab notes, brainstorms, class planning
- **Not authoritative** for product behavior
- May use `TODO` and `Decision Needed` freely
- `documentation_backlog.md` tracks drafting priorities; do not treat it as requirements
- **Do not update the backlog automatically.** Do not mark items in `documentation_backlog.md` complete or change its status entries unless the task explicitly includes backlog maintenance.

### Reference documents (`docs/references/`)

- Preserve teacher-provided or external templates (e.g. `_TEMPLATE.md`)
- Do not delete reference templates without explicit user approval
- A Home Cook-specific derivative template may be added later; keep the original reference intact

### Report documents (`docs/reports/`)

- Record what changed, why, and what needs review
- Factual and historical — not product requirements
- Use after reorganization, cleanup, or major documentation tasks
- **Historical reports are frozen.** Do not rewrite existing reports in `docs/reports/` unless the user explicitly asks for a correction, update, or follow-up report. When new events supersede a report, prefer a new follow-up report over editing the original.

### Design documents (`docs/design/`)

- Wireframes, brand, typography, UI notes
- Do not encode business rules or architecture decisions here

## Architectural Principles to Preserve

When writing technical documentation, align with `System_Architecture.md`:

- The Home Cook is a **unified kitchen management system**, not isolated tools.
- Layers: **Presentation** → **Application / Use Cases** → **Domain** → **Infrastructure**
- **Core domains:** Pantry, Recipes
- **Planning domains:** Shopping, Meal Planning
- **Supporting domains:** Cooking Assistance Tools, User Preferences
- Domains may **use** information from other domains but must not **own** each other's data
- Cross-domain workflows are coordinated by the **Application / Use Case** layer
- External services support the system without owning core business behavior
- **User confirmation** is required before important automated changes to user-managed data
- Core business behavior stays independent of UI, persistence, platform services, external APIs, AI providers, and state-management packages

If documentation conflicts with these principles, flag the conflict — do not silently "fix" authoritative docs.

## Avoiding Duplication

1. **One home per fact** — each concept should have one primary document.
2. **Link, don't copy** — use relative markdown links to authoritative sections.
3. **Summarize at lower levels** — support docs may summarize in 1–2 sentences, then link upstream.
4. **No second SRS** — do not recreate requirements tables in architecture or planning docs.
5. **No second architecture** — do not restate full layer/domain diagrams in every support doc.

## Handling Uncertainty

Never silently invent major decisions. Mark uncertainty explicitly.

### Standard markers

```markdown
> **TODO:** Describe local storage adapter approach after spike completes.

> **Decision Needed:** Choose conflict resolution strategy for offline pantry edits.
```

Inline form (acceptable in tables or lists):

- `TODO: ...`
- `Decision Needed: ...`

### When to mark uncertainty

Use markers for:

- Unchosen technologies, providers, or patterns
- Schema details not yet validated
- Sync, privacy, AI, or auth behavior not yet approved
- Conflicting hints between existing documents

### When not to guess

Do **not** invent without review:

- Database schema commitments
- Sync/conflict-resolution policy
- AI automation scope
- Supabase/auth/storage wiring details
- Domain ownership changes
- New product requirements

## Preserving Existing Content

When editing existing files:

1. **Read the full file first**
2. **Preserve** approved content unless the user asked for revision
3. **Do not overwrite** if merge is safer — prefer additive edits or clearly marked draft sections
4. **Do not delete** planning or reference files without explicit approval
5. **Formatting-only passes** require explicit user request — do not change wording

If a target file already exists and is not a placeholder:

- Extend or revise surgically
- Do not replace authoritative content with AI drafts

## Handling Conflicts Between Documents

1. Identify the conflict explicitly in your response or report.
2. Apply authority order:
   - `Product_Specification.md` for product intent
   - `System_Architecture.md` for structure and technical boundaries
   - `Decision_Log.md` for confirmed decisions (once populated)
   - Planning/reference/report docs are lowest authority
3. Do not edit authoritative docs to resolve conflicts unless the user directs it.
4. Propose resolution with `Decision Needed` markers in draft/support docs.

## Draft Workflow for Human Review

All AI-generated documentation is draft until the user approves it.

### Draft-status rules

- New or heavily rewritten support docs **must** include a draft/pending-review status block at the top.
- Already-approved authoritative documents must **not** have draft status blocks added unless the user explicitly asks to convert them back to draft status.
- Removing a draft status block requires explicit user approval — that is what marks the document as reviewed.

### At the top of new or heavily rewritten docs

```markdown
> **Status:** Draft — pending human review.
>
> This document was generated as a starting point. It is not authoritative until reviewed and approved.
```

Placeholders may also use:

```markdown
> **Status:** Placeholder — not yet written.
```

### Source note for architecture support drafts

New drafts of architecture support documents (`docs/architecture/`) should include a source note directly below the status block, naming the documents that informed the draft:

```markdown
> **Sources:** Product Specification, System Architecture, and documentation backlog.
```

### Drafting steps

1. State which source documents informed the draft (use the source note above for architecture support docs)
2. Write within the target document's single responsibility
3. Mark uncertainties with `TODO` / `Decision Needed`
4. List assumptions and review questions at the end (or in a separate report if large)
5. Do not present draft content as finalized policy

## Markdown Style Expectations

Match existing project conventions:

- Use readable title-case file names: `Development_Standards.md`, `Product_Specification.md`
- Prefer `##` / `###` hierarchy; use `####` for requirement-level items when appropriate
- Use markdown tables for comparisons and indexes
- Use relative links within the repo
- Use GitHub callouts when they aid scanning:
  - `> [!NOTE]` for introductory context (as in Product Specification)
  - `> **Status:**` for draft/placeholder/review state
- Use `---` sparingly for major section breaks in long docs
- Keep prose clear and direct; avoid marketing language in technical docs
- Use consistent terminology: **domain**, **layer**, **Pantry**, **Recipes**, **The Home Cook**

## Post-Task Reporting

After documentation work, summarize for the user:

1. **What changed** — files created, edited, moved (if any)
2. **What did not change** — especially authoritative docs left untouched
3. **Sources used** — which files informed the work
4. **Assumptions made**
5. **Decisions needing review** — list every `Decision Needed` item
6. **Recommended next step**

For large tasks, add or update a report in `docs/reports/` or `docs/planning/` as appropriate.

## Preventing Accidentally Authoritative AI Docs

- Never imply AI drafts are approved policy
- Do not update `START_HERE/` foundational files unless explicitly requested
- Do not move files or reorganize structure unless explicitly requested
- Do not delete `docs/references/_TEMPLATE.md`
- Do not fill `Decision_Log.md` with assumed decisions — only seed entries clearly labeled for review
- Do not rewrite historical reports in `docs/reports/` unless the user explicitly asks for a correction, update, or follow-up
- Do not mark `docs/planning/documentation_backlog.md` items complete or update its status unless the task explicitly includes backlog maintenance — report completed work to the user instead
- Do not add draft status blocks to already-approved authoritative documents unless the user explicitly asks to convert them back to draft

## Quick Decision Tree

```
Is this about what the product must do?
  → Product_Specification.md (or planning doc if exploratory)

Is this about system structure, domains, or layers?
  → System_Architecture.md (or architecture support doc)

Is this implementation convention or contributor guidance?
  → docs/architecture/Development_Standards.md

Is this a backlog item, story, or lab note?
  → docs/planning/

Is this a template or external example?
  → docs/references/

Is this a record of a completed documentation task?
  → docs/reports/

Is this wireframes / brand / UI?
  → docs/design/
```

## Additional Reference

- Document path map and folder rules: [reference.md](reference.md)
- Drafting priorities and per-file notes: [docs/planning/documentation_backlog.md](../../../docs/planning/documentation_backlog.md)
