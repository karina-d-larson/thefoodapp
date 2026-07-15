# Development Standards

> **Status:** Draft — pending human review.
>
> This document was generated as a starting point. It is not authoritative until reviewed and approved.

> **Sources:** Product Specification, System Architecture, and documentation backlog.

## 1. Purpose

This document defines how human contributors and AI coding assistants should build **The Home Cook** consistently. It establishes coding conventions, project organization expectations, testing and review practices, and collaboration rules that support the architecture without redefining it.

Development standards exist to make the codebase:

* easier to understand and maintain
* aligned with the layered architecture and domain boundaries
* testable and reviewable
* safe to extend as pantry, recipe, shopping, meal planning, and supporting features grow

## 2. Relationship to Authoritative Documents

| Document | Role relative to this document |
| :--- | :--- |
| [Product_Specification.md](../../START_HERE/Product_Specification.md) | Defines **what** the product must accomplish, including quality, accessibility, and maintainability requirements |
| [System_Architecture.md](../../START_HERE/System_Architecture.md) | Defines **how** the system is structured — layers, domains, data flow, state management, persistence boundaries, and dependency rules |
| [START_HERE.md](../../START_HERE/START_HERE.md) | Defines how project documentation is organized |

This document translates those authoritative sources into **implementation guidance**. It does not replace them.

When guidance conflicts:

1. [Product_Specification.md](../../START_HERE/Product_Specification.md) governs product intent
2. [System_Architecture.md](../../START_HERE/System_Architecture.md) governs structure and technical boundaries
3. This document governs day-to-day development practice

If a conflict cannot be resolved during implementation, mark it `Decision Needed` and record the outcome in [Decision_Log.md](Decision_Log.md) after review.

## Technology Baseline

The project currently uses the following technologies. This table is a baseline reference, not a decision document.

| Area | Technology |
| :--- | :--- |
| Frontend | Flutter / Dart |
| State management | Riverpod |
| Backend services | Supabase |
| Database | PostgreSQL through Supabase |
| Auth | Supabase Auth |
| Storage | Supabase Storage |
| CI/CD | GitHub Actions |

## 3. Contributor Expectations

Contributors should:

* read [START_HERE.md](../../START_HERE/START_HERE.md) before making substantial documentation or code changes
* align changes with the [Product Specification](../../START_HERE/Product_Specification.md) and [System Architecture](../../START_HERE/System_Architecture.md)
* keep each change focused on one concern where practical
* preserve existing approved behavior unless the task explicitly changes it
* write or update tests for behavior they add or modify
* run local quality checks before opening a pull request
* document non-obvious decisions and mark uncertainty clearly
* request review for architectural, persistence, AI, or dependency changes

Contributors should **not**:

* add product requirements in code or docs outside the Product Specification
* bypass domain ownership rules for convenience
* commit secrets, credentials, or local environment files
* treat AI-generated output as approved without review

## 4. AI Coding Assistant Expectations

AI coding assistants (including Cursor) should follow the same architectural and quality boundaries as human contributors.

AI assistants must:

* read authoritative docs before substantial changes
* follow this document and [System_Architecture.md](../../START_HERE/System_Architecture.md)
* produce review-ready diffs, not silently authoritative policy
* mark uncertain implementation choices with `TODO` or `Decision Needed` in code comments or draft docs
* avoid inventing database schema, sync policy, auth flows, or automation behavior without human review
* coordinate cross-domain changes through the Application / Use Case layer
* require user confirmation flows before persisting important automated changes to user-managed data

AI assistants must **not**:

* rewrite [Product_Specification.md](../../START_HERE/Product_Specification.md), [System_Architecture.md](../../START_HERE/System_Architecture.md), or historical reports unless explicitly asked
* fill [Decision_Log.md](Decision_Log.md) with assumed decisions
* move or delete `docs/references/_TEMPLATE.md`
* mark backlog items complete without explicit backlog-maintenance instruction

> **TODO:** Expand AI-specific collaboration rules in [AI_Guidelines.md](AI_Guidelines.md) after this document is reviewed.

## 5. Project Structure Expectations

The codebase should evolve to reflect the layered architecture described in [System_Architecture.md](../../START_HERE/System_Architecture.md). Folders and modules should make layer and domain responsibility obvious.

### 5.1 Current repository layout

The project currently includes:

| Path | Purpose |
| :--- | :--- |
| `lib/` | Flutter application source |
| `test/` | Unit and widget tests |
| `integration_test/` | Integration tests |
| `web/` | Flutter web assets |
| `.github/workflows/` | CI/CD pipeline |

The application source is still early-stage. Structure rules below describe the **intended direction**, not a fully implemented layout.

### 5.2 Recommended code organization

The default `lib/` structure should follow the layered architecture:

```
lib/
  presentation/
  application/
  domain/
  infrastructure/
  shared/
```

For domain-specific code, use domain folders under `lib/domain/` where practical:

```
lib/domain/
  pantry/
  recipes/
  shopping/
  meal_planning/
  cooking_tools/
  user_preferences/
```

Application and Infrastructure may mirror domain folders when it improves clarity, but layer boundaries remain primary.

| Layer | Intended responsibility | Default location |
| :--- | :--- | :--- |
| Presentation | Screens, widgets, navigation, UI state | `lib/presentation/` |
| Application / Use Cases | Workflow coordination across domains | `lib/application/` |
| Domain | Business rules and domain models | `lib/domain/` |
| Infrastructure | Persistence, Supabase adapters, platform services | `lib/infrastructure/` |
| Shared | Minimal cross-cutting primitives used across layers | `lib/shared/` |

Domains within `lib/domain/`:

* `pantry/`
* `recipes/`
* `shopping/`
* `meal_planning/`
* `cooking_tools/`
* `user_preferences/`

> **TODO:** Expand Application and Infrastructure domain-mirrored subfolders when the first features need them.

### 5.3 File placement rules

* UI widgets and screens belong in Presentation.
* Workflow orchestration belongs in Application / Use Cases.
* Business rules and domain entities belong in Domain.
* Supabase clients, repository implementations, and platform adapters belong in Infrastructure.
* Shared primitives used across layers belong in `lib/shared/` and should be minimal and reviewed carefully.

Do not place persistence queries, Supabase calls, or external API logic directly in widgets.

## 6. Naming Conventions

### 6.1 Dart and Flutter

| Item | Convention | Example |
| :--- | :--- | :--- |
| Files | `snake_case.dart` | `pantry_item_card.dart` |
| Classes / enums / typedefs | `UpperCamelCase` | `PantryItem`, `RecipeRepository` |
| Variables, parameters, methods | `lowerCamelCase` | `pantryItems`, `loadRecipes()` |
| Constants | `lowerCamelCase` preferred; `SCREAMING_SNAKE_CASE` only for legacy or generated code | `defaultServingSize` |
| Private members | leading `_` | `_filterPantryItems()` |
| Tests | mirror source path and add `_test` suffix | `pantry_item_card_test.dart` |

### 6.2 Domain and layer naming

* Use product language from the Product Specification: **Pantry**, **Recipes**, **Shopping**, **Meal Planning**, **Cooking Assistance Tools**, **User Preferences**.
* Repository interfaces should describe capability, not storage technology: `PantryRepository`, not `SupabasePantryTable`.
* Use case / workflow names should describe user intent: `CompleteShoppingTrip`, `ConfirmRecipeConsumption`.
* Avoid vague names such as `Manager`, `Helper`, or `Utils` unless the responsibility is explicit and narrow.

### 6.3 Documentation files

* Use readable title-case names for project docs: `Development_Standards.md`, `Product_Specification.md`.
* Use lowercase folder names under `docs/`: `architecture/`, `planning/`, `references/`, `reports/`, `design/`.

## 7. Flutter and Dart Coding Standards

### 7.1 Language and tooling

* Use **Flutter stable** and the Dart SDK constraint declared in `pubspec.yaml`.
* Follow the lint rules in `analysis_options.yaml` and `package:flutter_lints`.
* Format code with `dart format` before submitting changes.
* Resolve `flutter analyze` findings; do not ignore new analyzer warnings without review.

### 7.2 General Dart practices

* Prefer `const` constructors and declarations where the linter recommends them.
* Keep widgets small and composable; extract widgets when presentation logic grows.
* Favor immutable models for domain data where practical.
* Use explicit types when they improve readability; avoid unnecessary `dynamic`.
* Handle errors deliberately; do not swallow exceptions silently.
* Keep build methods focused on layout and presentation; move business logic out of widgets.

### 7.3 Dependencies

Current important declared dependencies include:

* `flutter_riverpod` for state management
* `supabase_flutter` for backend integration

Dependency rules:

* New dependencies should be added only when they solve a clear project need, are actively maintained, fit the architecture, and are approved by the project owner before being committed.
* prefer Flutter- and Dart-idiomatic packages with active maintenance
* do not let UI packages leak into Domain code
* document significant dependency additions in pull requests

### 7.4 Generated and platform code

* Do not manually edit generated files unless the task explicitly requires it.
* Keep platform-specific code isolated in Infrastructure or thin platform adapters.

## 8. State Management Expectations

The project uses **Riverpod** (`flutter_riverpod`) as the state-management package. Riverpod is an implementation choice. Architectural state rules come from [System_Architecture.md](../../START_HERE/System_Architecture.md) Section 7.

### 8.1 Architectural state rules

State management must preserve:

* domain ownership boundaries
* separation of interface state, application state, domain state, persisted state, and external/suggested state
* coordination of cross-domain updates through the Application / Use Case layer
* user confirmation before automated suggestions become committed user data

### 8.2 Riverpod usage expectations

* expose application and domain state through providers/notifiers with clear ownership
* keep ephemeral UI state local to widgets or narrowly scoped providers when it does not belong to a domain
* avoid using providers as a bypass around domain rules or use-case coordination
* prefer derived providers for computed state (for example, missing ingredients) instead of duplicating authoritative data
* do not persist suggested or imported external data without an explicit user-confirmed workflow

> **Decision Needed:** Define provider naming conventions and folder placement for Riverpod providers (for example, co-located with features vs `application/providers/`).

> **TODO:** Document approved Riverpod patterns (Notifier vs AsyncNotifier, repository injection, family providers) after the first domain feature is implemented.

## 9. Domain, Application, and Infrastructure Separation

Follow the dependency direction defined in [System_Architecture.md](../../START_HERE/System_Architecture.md) Section 9:

```
Presentation
    ↓
Application / Use Cases
    ↓
Domain
    ↑
Infrastructure implements interfaces
```

### 9.1 Presentation

* renders state and captures user intent
* must not own core business rules
* must not call Supabase or persistence implementations directly for domain behavior

### 9.2 Application / Use Cases

* coordinates workflows that span one or more domains
* validates and sequences user-confirmed changes
* depends on Domain and abstractions for persistence or external services
* must not absorb domain ownership (Pantry still owns inventory rules)

### 9.3 Domain

* contains business rules, entities, and domain-specific logic
* remains independent of Flutter widgets, Supabase, and platform APIs
* must not depend on Infrastructure or Presentation

### 9.4 Infrastructure

* implements repositories, persistence, Supabase integration, and external service adapters
* fulfills interfaces required by Application or Domain layers
* must not define product behavior that belongs in Domain

> **TODO:** Add concrete interface examples when [Persistence.md](Persistence.md) and repository contracts are drafted.

## 10. Persistence and External Service Boundaries

Persistence and external-service implementation details belong in Infrastructure. See [System_Architecture.md](../../START_HERE/System_Architecture.md) Sections 6 and 8 and [Persistence.md](Persistence.md).

### 10.1 Environment and Secrets

* service role keys must never be included in client code
* secrets and `.env` files must not be committed
* environment-specific configuration should remain outside domain logic
* any secret exposure should be treated as a security issue and rotated immediately
* public client-side keys should only be used according to Supabase/Flutter client-side best practices

### 10.2 Implementation rules

* Domain and Application layers depend on **abstractions**, not concrete Supabase or storage classes.
* Supabase/PostgreSQL, Supabase Auth, and Supabase Storage are infrastructure concerns.
* Supabase/PostgreSQL is the chosen backend and remote persistence layer. Local storage is required for offline-capable workflows, but the exact source-of-truth and sync relationship between local storage and Supabase/PostgreSQL remains a `Decision Needed` item (see [Persistence.md](Persistence.md)).
* Core workflows should be designed to remain usable without continuous connectivity whenever practical.
* external imports, AI output, and scanned data are **suggested state** until the user confirms
* one domain must not persist another domain's owned data through hidden side effects

> **Decision Needed:** Define the initial local storage role and the source-of-truth relationship between local storage and Supabase/PostgreSQL.

> **TODO:** Document repository interface naming and file placement per [Persistence.md](Persistence.md).

## 11. Accessibility Expectations

Accessibility expectations are defined in the Product Specification (QR-21 through QR-25). This section describes how implementation should support them.

Contributors should:

* use Flutter widgets and semantics that work with platform accessibility services
* ensure text remains readable across supported text scaling options
* not rely on color alone to communicate status or importance
* provide meaningful labels for interactive controls
* test important flows with accessibility features in mind

> **TODO:** Define the project's accessibility test checklist (for example, screen reader spot checks, text scale verification, contrast review).

> **Decision Needed:** Confirm whether a specific WCAG conformance target beyond platform accessibility support is required for this project.

## 12. Testing Expectations

Testing should protect domain behavior, workflow coordination, and critical user flows without redefining requirements.

### 12.1 Test types

| Type | Location | Purpose |
| :--- | :--- | :--- |
| Unit tests | `test/` | Domain logic, use cases, parsing/mapping, derived-state rules |
| Widget tests | `test/` | Presentation behavior and user-visible states |
| Integration tests | `integration_test/` | End-to-end app flows across layers |

### 12.2 General testing rules

* write tests for new behavior and bug fixes where practical
* prefer testing domain and application logic directly rather than only through widgets
* use deterministic tests; avoid real network calls in unit and widget tests
* mock or fake repositories and external services in unit tests
* name tests after behavior, using Home Cook domain language where helpful
* keep tests readable and focused on one behavior per test case

### 12.3 CI expectations

The GitHub Actions workflow currently runs on pull requests and pushes to `main`:

* `dart format --output=none --set-exit-if-changed .`
* `flutter analyze`
* `flutter test`
* integration tests on a headless Linux desktop target
* `flutter build web`

Pull requests should pass CI before merge unless a reviewer explicitly approves a temporary exception.

> **TODO:** Define minimum test coverage expectations or critical-path test list.

> **Decision Needed:** Confirm whether coverage reporting should be added to CI.

## 13. Documentation Expectations

Code changes and architecture-relevant work should stay aligned with the documentation system described in [START_HERE.md](../../START_HERE/START_HERE.md).

Contributors should:

* update documentation when behavior, conventions, or boundaries change
* keep docs in the correct folder (`architecture/`, `planning/`, `design/`, `references/`, `reports/`)
* link to authoritative docs instead of copying large sections
* mark draft docs with a status block until reviewed
* use `TODO` and `Decision Needed` for uncertain details
* add significant approved decisions to [Decision_Log.md](Decision_Log.md)

Contributors should **not** treat planning notes, AI drafts, or reports as product requirements.

For documentation writing workflow, follow `.cursor/skills/home-cook-documentation/SKILL.md`.

## 14. Git, Commit, Branch, and Pull Request Expectations

### 14.1 Branches

Use this branch naming convention:

* `feature/<short-description>`
* `fix/<short-description>`
* `docs/<short-description>`
* `refactor/<short-description>`
* `chore/<short-description>`

Examples:

* `feature/pantry-add-item`
* `fix/recipe-filter-bug`
* `docs/persistence-draft`
* `refactor/domain-structure`
* `chore/update-ci`

Additional guidance:

* keep descriptions short and descriptive
* separate feature work, documentation work, and fixes when practical
* target `main` for integration unless a different release process is defined

### 14.2 Commits

* make commits focused and logically grouped
* write commit messages that explain **why**, not only what changed
* avoid mixing unrelated refactors with feature work unless necessary and called out in the pull request

> **TODO:** Adopt a formal commit message convention (for example, Conventional Commits) if the project owner wants one.

### 14.3 Pull requests

Pull requests should include:

* a concise summary of the change
* linked issue or task reference when available
* test notes (`flutter test`, integration tests run, or why not)
* documentation updates included or explicitly not needed
* screenshots or recordings for user-visible UI changes when helpful
* called-out `Decision Needed` items for reviewer attention

Do not merge changes that introduce secrets or bypass user-confirmation rules for automated data changes.

## 15. Review Requirements

### 15.1 Standard review

All non-trivial changes should be reviewed before merge to `main` when practical. When working solo, the project owner should perform a self-review before merging.

Reviewers should check:

* alignment with the Product Specification and System Architecture
* respect for domain ownership and dependency direction
* test coverage for new behavior
* documentation updates where conventions or behavior changed
* absence of secrets and accidental authoritative AI documentation

### 15.2 Review triggers for careful review

Seek explicit review from the project owner for changes involving:

* persistence strategy or repository contracts
* Supabase schema, auth, or storage usage
* cross-domain workflow behavior
* state-management architecture
* new third-party dependencies
* AI-assisted automation or data modification
* accessibility-impacting UI changes
* CI/CD or release process changes

## 16. What This Document Does Not Define

This document does **not** define:

| Topic | Defined in |
| :--- | :--- |
| Product requirements, scope, or quality requirements | [Product_Specification.md](../../START_HERE/Product_Specification.md) |
| Layer, domain, data-flow, and dependency architecture | [System_Architecture.md](../../START_HERE/System_Architecture.md) |
| Persistence strategy and storage abstractions | [Persistence.md](Persistence.md) |
| Database entities and relationships | [Database.md](Database.md) |
| AI automation boundaries and privacy rules | [AI_Guidelines.md](AI_Guidelines.md) |
| Recorded architectural decisions | [Decision_Log.md](Decision_Log.md) |
| Release sequencing and milestones | [Roadmap.md](Roadmap.md) |
| Feature stories and backlog status | `docs/planning/` |

## 17. Review Items for Human Approval

The following items need review before this document can be treated as approved:

| Marker | Item |
| :--- | :--- |
| Decision Needed | Riverpod provider naming and placement conventions |
| Decision Needed | Initial local storage role and source-of-truth relationship with Supabase/PostgreSQL |
| Decision Needed | WCAG conformance target beyond platform accessibility support |
| Decision Needed | Coverage reporting in CI |
| TODO | Expand Application and Infrastructure domain-mirrored subfolders when first features need them |
| TODO | Document approved Riverpod patterns after first domain feature |
| TODO | Add repository interface examples after Persistence draft |
| TODO | Define accessibility test checklist |
| TODO | Adopt formal commit message convention if desired |
| TODO | Expand AI rules in AI_Guidelines.md |

## 18. Related Documents

* [Product_Specification.md](../../START_HERE/Product_Specification.md)
* [System_Architecture.md](../../START_HERE/System_Architecture.md)
* [START_HERE.md](../../START_HERE/START_HERE.md)
* [Persistence.md](Persistence.md)
* [Database.md](Database.md)
* [AI_Guidelines.md](AI_Guidelines.md)
* [Decision_Log.md](Decision_Log.md)
