# The Home Cook Documentation Backlog

> [!NOTE]
> This file tracks documentation that needs to be drafted, reviewed, revised, or completed. It is a planning document, not an authoritative product or architecture document.

## Current Documentation Priorities

The foundational documents have been created and moved into `START_HERE/`:

* `START_HERE/START_HERE.md`
* `START_HERE/Product_Specification.md`
* `START_HERE/System_Architecture.md`

The next priority is drafting the architecture support documents in `docs/architecture/`.

## Recommended Drafting Order

| Priority | Document                                     | Status      | Suggested Approach                                                 |
| -------- | -------------------------------------------- | ----------- | ------------------------------------------------------------------ |
| 1        | `docs/architecture/Development_Standards.md` | Placeholder | AI draft, careful human review                                     |
| 2        | `docs/architecture/Persistence.md`           | Placeholder | Work carefully; affects storage, offline behavior, and future sync |
| 3        | `docs/architecture/Database.md`              | Placeholder | Work carefully; affects long-term data model                       |
| 4        | `docs/architecture/AI_Guidelines.md`         | Placeholder | Work carefully; affects automation, privacy, and user control      |
| 5        | `docs/architecture/Decision_Log.md`          | Placeholder | AI can create template and seed known decisions for review         |
| 6        | `docs/architecture/Roadmap.md`               | Placeholder | AI draft, owner decides priorities                                 |

## Document Drafting Notes

### Development_Standards.md

Purpose:

Define how human contributors and AI coding assistants should build the project consistently.

Should include:

* project structure expectations
* naming conventions
* coding standards
* documentation expectations
* testing expectations
* accessibility expectations
* commit, branch, and pull request guidance
* AI collaboration rules
* review requirements

Needs review for:

* Flutter/Dart standards
* Riverpod usage
* Supabase usage
* testing expectations
* folder structure
* dependency rules
* formatting and linting expectations

### Persistence.md

Purpose:

Define how application data is stored, accessed, abstracted, and prepared for future synchronization.

Should include:

* persistence principles
* local-first expectations
* repository/interface boundaries
* persistence ownership by domain
* future sync considerations
* data integrity expectations
* what belongs in Persistence vs Database

Should avoid:

* full table definitions
* SQL schema
* migrations
* provider-specific implementation details unless already decided

Needs review for:

* local storage approach
* Supabase/PostgreSQL relationship
* offline-first behavior
* future sync strategy
* conflict resolution

### Database.md

Purpose:

Define the logical and physical data model.

Should include:

* major entities
* relationships
* ownership boundaries
* entity responsibilities
* conceptual fields
* data integrity considerations
* future schema concerns

Should avoid:

* overfitting schema too early
* making recipe ingredients and pantry items the same thing without review
* making shopping items the source of truth for pantry inventory
* putting business rules into database behavior

Needs review for:

* ingredient matching strategy
* recipe versioning
* shopping history model
* meal history model
* sync IDs and timestamps
* future accounts or household sharing

### AI_Guidelines.md

Purpose:

Define how AI assistance should support the application without controlling core user data.

Should include:

* AI as support, not authority
* user confirmation requirements
* privacy and data exposure rules
* suggested vs committed state
* AI use cases
* prohibited or high-risk AI behavior
* prompt/output review expectations
* future provider replaceability

Needs review for:

* privacy-sensitive workflows
* AI-generated pantry changes
* AI-generated recipe edits
* scanning and OCR results
* nutrition or health-related boundaries
* automation that could reduce user control

### Decision_Log.md

Purpose:

Record significant project decisions and reasoning.

Should include:

* decision log template
* known confirmed decisions
* date
* decision
* context
* alternatives considered
* final choice
* reasoning
* consequences
* related documents

Should avoid:

* inventing decisions that were not made
* treating uncertain assumptions as final

Known decisions that may be considered for seeding after review:

* The Home Cook is a unified kitchen management system, not isolated tools.
* Product Specification and System Architecture are foundational documents.
* The architecture uses Presentation, Application / Use Cases, Domain, and Infrastructure layers.
* Pantry and Recipes are core domains.
* Shopping and Meal Planning are planning domains.
* Cooking Assistance Tools and User Preferences are supporting domains.
* External services are optional helpers, not core authorities.
* User confirmation is required for important automated data changes.
* Documentation has been reorganized into `START_HERE/`, `docs/architecture/`, `docs/planning/`, `docs/design/`, `docs/references/`, and `docs/reports/`.

### Roadmap.md

Purpose:

Track long-term development direction without redefining product requirements.

Should include:

* broad phases
* milestone ideas
* near-term priorities
* later enhancements
* future expansion areas
* relationship to Product Specification

Should avoid:

* exact timelines unless requested
* treating future ideas as committed release promises
* redefining requirements

Needs review for:

* current development stage
* school/project deadlines
* personal project priorities
* what should be MVP vs later
* dependencies between phases

## General Backlog Notes

All generated documentation should be treated as draft content until reviewed.

Major technical or architectural decisions should be recorded in `docs/architecture/Decision_Log.md`.

Any uncertainty should be marked with `TODO` or `Decision Needed`.

The Product Specification and System Architecture should remain the primary guides for all support documentation.
