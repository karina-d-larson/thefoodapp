# Persistence

> **Status:** Draft — pending human review.
>
> This document was generated as a starting point. It is not authoritative until reviewed and approved.

> **Sources:** Product Specification, System Architecture, documentation backlog, and Development Standards.

## 1. Purpose

This document defines how **The Home Cook** approaches storing and retrieving application data. It describes persistence strategy, data-access boundaries, offline-capable expectations, and architectural preparation for synchronization between local and remote storage.

Persistence exists to support the application's domains — not to define business behavior. This document translates persistence-related requirements and architectural decisions into implementation guidance without specifying database schema, SQL, or concrete storage packages.

## 2. Relationship to Authoritative and Support Documents

| Document | Role relative to this document |
| :--- | :--- |
| [Product_Specification.md](../../START_HERE/Product_Specification.md) | Defines **what** must be persisted, quality expectations (integrity, session persistence, AC-3 offline support expectations), and architectural constraints (AC-1 through AC-3) |
| [System_Architecture.md](../../START_HERE/System_Architecture.md) | Defines **how** persistence fits into layers, domain ownership, repository boundaries, workflow coordination, and future sync posture (Section 6) |
| [Database.md](Database.md) | Defines the logical and physical **data model** — entities, relationships, and conceptual fields |
| [Development_Standards.md](Development_Standards.md) | Defines how contributors implement persistence abstractions in code |
| [START_HERE.md](../../START_HERE/START_HERE.md) | Defines how project documentation is organized |

### 2.1 Persistence vs Database

| Topic | Defined in |
| :--- | :--- |
| Storage strategy, offline-capable posture, repository boundaries | **This document** (`Persistence.md`) |
| Entity definitions, relationships, conceptual fields | [Database.md](Database.md) |
| Layer placement and domain ownership | [System_Architecture.md](../../START_HERE/System_Architecture.md) |
| Coding conventions for repositories and Infrastructure | [Development_Standards.md](Development_Standards.md) |

Do not duplicate the data-ownership table or full persistence principles from [System_Architecture.md](../../START_HERE/System_Architecture.md) Section 6. Reference that section when architectural context is needed.

### 2.2 Conflict resolution

If guidance conflicts:

1. [Product_Specification.md](../../START_HERE/Product_Specification.md) governs product intent
2. [System_Architecture.md](../../START_HERE/System_Architecture.md) governs structural boundaries
3. This document governs persistence strategy and access patterns
4. [Database.md](Database.md) governs data model details once drafted

Unresolved conflicts should be marked `Decision Needed` and recorded in [Decision_Log.md](Decision_Log.md) after review.

## 3. Persistence Principles

Persistence in The Home Cook follows these principles, aligned with [System_Architecture.md](../../START_HERE/System_Architecture.md) Section 6.1 and Product Specification constraints AC-1, AC-2, and AC-3:

* **Reliable durable storage** — core user data should remain available between application sessions (QR-12).
* **Offline-capable core behavior** — core workflows should be designed to remain usable without continuous network connectivity whenever practical (AC-3).
* **Independence from implementation** — business logic must not depend directly on a specific database, storage library, or cloud provider (AC-1, AC-4).
* **Abstract access** — persisted data is accessed through defined interfaces or repositories, not concrete storage classes (AC-2).
* **Domain-aligned ownership** — stored data reflects domain ownership boundaries; persistence does not redefine who owns what.
* **Replaceable implementations** — storage technologies may change without rewriting Domain behavior.
* **Sync-ready, not sync-dependent** — future synchronization may be added without redesigning core business behavior.
* **User-confirmed commits** — external or suggested data becomes durable only after user review and confirmation.

Persistence supports domains. It does not own domain rules.

## 4. Local and Offline Storage

The Home Cook is intended to support **offline-capable** workflows. Local storage is required for offline-capable workflows, but local storage is **not necessarily the primary persistence model** for all core user data.

**Supabase/PostgreSQL** is the chosen backend and remote persistence layer. Local storage supports offline-capable behavior, local continuity, and related persistence needs depending on the final strategy. The exact source-of-truth and sync relationship between local storage and Supabase/PostgreSQL remains a `Decision Needed` item.

Local storage support may be used for:

* cached data
* local drafts
* offline viewing
* offline edits
* queued changes
* temporary continuity when Supabase is unavailable

Users should be able to work with core data in offline-capable ways where practical, including pantry items, recipes, shopping lists, meal plans, and application preferences — for example when using recipes and shopping lists away from home or in areas with poor network coverage.

The exact responsibilities of local storage — including what is cached, drafted, queued, or treated as durable on-device — are still subject to human review. See Section 12.3 for the source-of-truth and sync decision.

> **Decision Needed:** Choose the initial on-device persistence technology for Flutter (for example, embedded local database, structured local store, or other approved approach).

## 5. Offline Behavior Expectations

Offline-capable behavior is an important product and architecture expectation for core workflows, even though the exact local storage and synchronization strategy is still subject to review.

### 5.1 What must work offline

Core workflows should remain usable without continuous network connectivity, including at minimum:

* viewing and managing pantry inventory
* viewing and managing saved recipes
* viewing and managing shopping lists
* viewing and managing meal plans
* accessing user preferences and application settings needed for core use

### 5.2 What may require connectivity

Optional or external capabilities may require network access, such as:

* recipe import from external sources
* AI-assisted suggestions
* future cloud sync or backup operations
* future third-party integrations

When connectivity is unavailable, the application should degrade gracefully: show clear feedback, preserve local data, and avoid silent data loss (QR-11, QR-13).

### 5.3 Suggested vs committed data offline

External or suggested information (imports, AI output, scanned results) must not automatically become committed persisted data. Suggested data may be held temporarily in application state until the user confirms it. See [System_Architecture.md](../../START_HERE/System_Architecture.md) Sections 7.9 and 6.5.

## 6. Repository and Interface Boundaries

The application must access persisted data through **defined interfaces** rather than direct dependence on a storage implementation (AC-2). Concrete implementations belong in the Infrastructure layer.

### 6.1 Repository role

A repository or persistence interface should describe **what the application needs to do**, such as:

* load all pantry items for a household
* save a recipe and its related data
* record a completed shopping activity
* persist a meal plan change after user confirmation

It should **not** expose unnecessary storage-specific concepts (SQL queries, table names, Supabase client details) to Domain or Application layers.

### 6.2 Interface placement

| Layer | Relationship to persistence interfaces |
| :--- | :--- |
| Domain | May define or depend on repository contracts; must not depend on concrete implementations |
| Application / Use Cases | Coordinates workflows; calls repositories through interfaces; sequences multi-domain persistence |
| Infrastructure | Implements repository interfaces using chosen storage technology |
| Presentation | Must not access persistence directly for domain behavior |

### 6.3 Interface design expectations

* one repository interface per domain persistence concern where practical (for example, `PantryRepository`, `RecipeRepository`)
* methods express domain operations, not storage mechanics
* interfaces should be testable with fakes or mocks
* implementations should be swappable without changing Domain rules

> **TODO:** Define repository interface naming, method conventions, and file placement after human review of this document.

> **TODO:** Add concrete interface examples when the first domain persistence feature is implemented.

### 6.4 Testing support

Repository interfaces enable unit and integration testing without real databases or network calls (AC-6). Fakes should be used in Domain and Application tests; real storage implementations should be tested in Infrastructure-level tests.

## 7. Separation of Persistence from Business Logic

Business rules belong in the **Domain** layer. Storage mechanics belong in **Infrastructure**. The Application / Use Case layer coordinates when persistence occurs — not what the business rules are.

Persistence must not:

* decide whether a shopping item should update pantry inventory
* calculate recipe availability from pantry data
* enforce domain validation rules that belong in Domain
* bypass user confirmation for automated changes

Persistence must:

* store and retrieve data as directed by Domain and Application layers
* support atomic or coordinated writes when a workflow updates multiple related records
* reflect the outcome of domain-approved state changes

This separation supports AC-1 and QR-16 (separation of concerns).

## 8. Domain Ownership and Persisted Data Ownership

Persisted data must align with domain ownership defined in [System_Architecture.md](../../START_HERE/System_Architecture.md) Sections 4.5, 5.2, and 6.3.

| Data category | Owning domain |
| :--- | :--- |
| Pantry item records, quantities, storage locations, freshness, stock status | Pantry |
| Recipe records, ingredients, instructions, notes, labels, folders, favorites, ratings, version history | Recipes |
| Shopping list records, items, purchase status, priorities, notes, shopping history | Shopping |
| Meal plan records, planned meals, completion status, skipped meals, meal history | Meal Planning |
| Timer records, measurement preferences, cooking utility state (when persistence is needed) | Cooking Assistance Tools |
| Application settings, defaults, onboarding status, personalization preferences | User Preferences |

### 8.1 Ownership rules

* Persistence stores data **for** a domain; it does not transfer domain ownership.
* One domain's repository should not silently write another domain's owned records without Application-layer coordination.
* Derived or computed information (for example, recipe availability, missing ingredients) should not be persisted as authoritative data when it can be recalculated from owned sources. See [System_Architecture.md](../../START_HERE/System_Architecture.md) Section 7.6.
* Shopping items are not the source of truth for pantry inventory. Pantry owns inventory state.

> **Decision Needed:** Confirm whether any derived data should be cached locally for performance and, if so, how cache invalidation is handled.

## 9. How Persistence Supports Cross-Domain Workflows

Cross-domain workflows are coordinated by the **Application / Use Case** layer. Persistence supports them by storing the results — not by defining workflow rules.

### 9.1 Example: completing a shopping trip

1. User confirms purchased items in the Shopping workflow.
2. Application / Use Case layer coordinates Shopping and Pantry behavior.
3. Shopping provides completed item information.
4. Pantry applies inventory updates after user confirmation.
5. Persistence stores the resulting changes for each affected domain.

The database does not decide that shopping completion updates pantry inventory.

### 9.2 Example: completing a recipe

1. User confirms a recipe was prepared.
2. Application / Use Case layer coordinates Recipes and Pantry.
3. Recipes provides ingredient usage information.
4. Pantry updates quantities after user confirmation.
5. Persistence stores updated pantry records.

### 9.3 Multi-record consistency

When a workflow updates records in more than one domain, persistence operations should support **consistent outcomes** aligned with domain behavior. The Application layer is responsible for sequencing; Infrastructure is responsible for reliable storage.

> **Decision Needed:** Define the transaction or consistency strategy for multi-domain writes (for example, single local transaction, saga-style compensation, or other approach).

> **TODO:** Document approved cross-domain persistence patterns after the first coordinated workflow is implemented.

## 10. Data Integrity Expectations

Persistence should protect user data from unnecessary loss, duplication, or inconsistency (QR-11).

### 10.1 Integrity expectations

* user data persists between sessions unless intentionally modified or removed (QR-12)
* confirmed user actions produce durable stored changes
* related records updated in one workflow remain consistent with intended domain behavior
* recoverable errors should not cause unnecessary data loss (QR-13)
* duplicate authoritative records should be avoided where practical (supports CBR-2 single source of truth)

### 10.2 Examples of integrity-sensitive workflows

* updating pantry inventory after confirmed recipe completion
* updating pantry inventory after confirmed shopping completion
* saving recipe edits without losing notes, labels, or organization
* preserving shopping history after completed shopping actions
* retaining meal history after planned meals are completed or skipped

### 10.3 What persistence does not guarantee alone

Integrity also depends on Domain rules and Application coordination. Persistence provides reliable storage; it does not replace business validation or user confirmation requirements.

## 11. Future Synchronization Considerations

Future synchronization may support cloud backup, multi-device use, shared household data, or integration with external services. Sync should be treated as an **extension of persistence**, not the foundation of core application behavior ([System_Architecture.md](../../START_HERE/System_Architecture.md) Section 6.6).

### 11.1 Architectural preparation (without final sync design)

The initial persistence strategy should allow future sync without redesigning Domain or Application behavior. Preparation includes:

* stable domain-owned data identities suitable for future sync metadata
* repository interfaces that can gain sync-aware implementations behind the same contracts
* clear separation between local and remote persistence responsibilities once source-of-truth is defined
* avoidance of business logic that assumes a single device or always-online storage

### 11.2 What is not decided yet

> **Decision Needed:** Choose a future synchronization strategy (for example, last-write-wins, operational transforms, domain-specific merge rules, or manual conflict resolution).

> **Decision Needed:** Define conflict resolution behavior for offline edits to the same record on multiple devices.

> **Decision Needed:** Determine whether multi-device or shared household sync is in scope for early releases or deferred to a later phase.

> **TODO:** Add sync metadata requirements to [Database.md](Database.md) after sync strategy is approved (for example, versioning fields, device identifiers, or timestamps — conceptual only until then).

Do not implement sync behavior or schema commitments until these decisions are reviewed and recorded.

## 12. Local Storage, Supabase, and PostgreSQL

The intended persistence-related technology stack for The Home Cook includes:

* **Flutter** frontend
* **Riverpod** for state management (see [Development_Standards.md](Development_Standards.md) and Section 13 below)
* **Supabase** backend services
* **PostgreSQL** database through Supabase
* **Supabase Auth** for identity and access
* **Supabase Storage** for file or media storage
* **On-device local storage** for offline-supported workflows

**Supabase/PostgreSQL** is the chosen backend and remote persistence layer. Local storage is required for offline-capable workflows, but the exact source-of-truth and sync relationship between local storage and Supabase/PostgreSQL remains a `Decision Needed` item. See [Development_Standards.md](Development_Standards.md) and [System_Architecture.md](../../START_HERE/System_Architecture.md) Section 8.

### 12.1 Role of each persistence layer

| Persistence layer | Architectural role |
| :--- | :--- |
| Supabase / PostgreSQL | Chosen remote database and backend persistence layer for account-based and cloud-backed data |
| Local on-device storage | Supports offline-capable workflows, cached data, local drafts, offline viewing, queued changes, or local continuity depending on final strategy |
| Supabase Auth | Supports identity and access for account-based features |
| Supabase Storage | Supports file or media storage for optional features |

### 12.2 Dependency rules

* Domain and Application layers must not depend directly on Supabase client APIs (AC-4).
* Core workflows should remain usable without continuous network connectivity whenever practical (AC-3).
* Supabase implementations belong in Infrastructure as concrete repository or adapter classes.
* PostgreSQL schema details belong in [Database.md](Database.md), not in this document.
* Local storage implementations also belong in Infrastructure behind repository abstractions.

### 12.3 Local-remote relationship

> **Decision Needed:** Define the source-of-truth and sync relationship between local storage and Supabase/PostgreSQL.

> **TODO:** Document the approved local-remote persistence architecture after the decision above is reviewed.

Do not commit Supabase keys, service role credentials, or `.env` files containing secrets.

## 13. Persistence and Application State

Persistence and state management are related but distinct ([System_Architecture.md](../../START_HERE/System_Architecture.md) Section 7.8).

| Concern | Managed by |
| :--- | :--- |
| What the app holds and displays while running | State management (see System Architecture Section 7) |
| What survives app restarts and sessions | Persistence (this document) |

Important domain state should be persisted when it represents lasting user information. Temporary interface state (open menus, unsaved form focus, loading indicators) should usually not be persisted unless it represents a user preference.

Riverpod and other state-management implementation details belong in [Development_Standards.md](Development_Standards.md), not here.

## 14. What This Document Does Not Define

This document does **not** define:

| Topic | Defined in |
| :--- | :--- |
| Product requirements or data requirement details | [Product_Specification.md](../../START_HERE/Product_Specification.md) |
| Layer, domain, and dependency architecture | [System_Architecture.md](../../START_HERE/System_Architecture.md) |
| Database tables, columns, ERDs, or SQL | [Database.md](Database.md) |
| Indexing, migration scripts, or query optimization | [Database.md](Database.md) or implementation docs |
| Specific storage packages or library choices (unless approved in Decision Log) | [Decision_Log.md](Decision_Log.md) |
| Final synchronization or conflict-resolution policy | [Decision_Log.md](Decision_Log.md) — after review |
| Coding conventions for repository implementations | [Development_Standards.md](Development_Standards.md) |
| State management provider patterns | [Development_Standards.md](Development_Standards.md) |

## 15. Decisions That Still Need Human Review

| Marker | Item |
| :--- | :--- |
| Decision Needed | Initial on-device persistence technology for Flutter |
| Decision Needed | Source-of-truth and sync relationship between local storage and Supabase/PostgreSQL |
| Decision Needed | Whether any derived data should be cached locally and how invalidation works |
| Decision Needed | Transaction or consistency strategy for multi-domain writes |
| Decision Needed | Future synchronization strategy |
| Decision Needed | Conflict resolution for offline multi-device edits |
| Decision Needed | Whether multi-device or shared household sync is in early scope |
| TODO | Define repository interface naming, method conventions, and file placement |
| TODO | Add concrete repository interface examples with first domain feature |
| TODO | Document approved cross-domain persistence patterns after first workflow |
| TODO | Add sync metadata requirements to Database.md after sync strategy is approved |
| TODO | Document approved local-remote persistence architecture after review |

## 16. Related Documents

* [Product_Specification.md](../../START_HERE/Product_Specification.md)
* [System_Architecture.md](../../START_HERE/System_Architecture.md)
* [START_HERE.md](../../START_HERE/START_HERE.md)
* [Database.md](Database.md)
* [Development_Standards.md](Development_Standards.md)
* [Decision_Log.md](Decision_Log.md)
