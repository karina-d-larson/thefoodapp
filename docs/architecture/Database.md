# Database

> **Status:** Draft — pending human review.
>
> This document was generated as a starting point. It is not authoritative until reviewed and approved.

> **Sources:** Product Specification, System Architecture, Persistence, Development Standards, and documentation backlog.

## 1. Purpose

This document defines the **logical and physical data model** for **The Home Cook**. It describes major entities, conceptual fields, relationships, ownership boundaries, and integrity expectations that support the product without encoding business rules in the database.

The database supports the application's domains. It does **not** own business rules, workflow decisions, or UI behavior. Those remain in the Domain and Application / Use Case layers described in [System_Architecture.md](../../START_HERE/System_Architecture.md).

This document:

* translates Product Specification data requirements (DR-1 through DR-6) into conceptual entity groups
* aligns stored data with domain ownership from System Architecture
* coordinates with [Persistence.md](Persistence.md) on what is stored vs how storage is accessed
* leaves SQL migrations, Supabase setup code, and Dart models out of scope

Do not treat conceptual fields below as a locked physical schema. Exact column names, types, indexes, and normalization choices remain subject to review.

## 2. Relationship to Authoritative and Support Documents

| Document | Role relative to this document |
| :--- | :--- |
| [Product_Specification.md](../../START_HERE/Product_Specification.md) | Defines **what** data the product must represent (DR-1 through DR-6) and quality expectations for integrity and session persistence |
| [System_Architecture.md](../../START_HERE/System_Architecture.md) | Defines **how** domains own data, how workflows coordinate updates, and persistence boundaries (Sections 4–6) |
| [Persistence.md](Persistence.md) | Defines storage strategy, repository interfaces, offline-capable posture, and local vs remote access patterns |
| [Development_Standards.md](Development_Standards.md) | Defines how contributors implement data access in Infrastructure without leaking schema details into Domain |

### 2.1 Database vs Persistence

| Topic | Defined in |
| :--- | :--- |
| Entities, relationships, conceptual fields, ownership of records | **This document** (`Database.md`) |
| Storage strategy, repositories, offline-capable access, sync posture | [Persistence.md](Persistence.md) |
| Domain rules and workflow decisions | [System_Architecture.md](../../START_HERE/System_Architecture.md) Domain and Application layers |
| Product data requirements | [Product_Specification.md](../../START_HERE/Product_Specification.md) Section 3.5 |

### 2.2 Conflict resolution

If guidance conflicts:

1. [Product_Specification.md](../../START_HERE/Product_Specification.md) governs product intent and required information
2. [System_Architecture.md](../../START_HERE/System_Architecture.md) governs ownership and structural boundaries
3. [Persistence.md](Persistence.md) governs storage strategy and access patterns
4. This document governs data model shape and conceptual fields

Unresolved conflicts should be marked `Decision Needed` and recorded in [Decision_Log.md](Decision_Log.md) after review.

## 3. Database Principles

* **Support domains, do not own rules** — tables and records store durable state; validation, matching logic, and workflow outcomes belong in Domain / Application layers.
* **Single authoritative representation where practical** — avoid duplicate sources of truth for the same user-managed fact (CBR-2).
* **Domain-aligned ownership** — each durable record has a clear owning domain. See [System_Architecture.md](../../START_HERE/System_Architecture.md) Section 6.3 and [Persistence.md](Persistence.md) Section 8.
* **Remote stack selected** — **Supabase/PostgreSQL** is the chosen backend and remote database stack.
* **Offline-capable, not offline-presumed as primary** — local storage is required for offline-capable workflows, but local storage is **not** assumed to be the primary source of truth. The source-of-truth and sync relationship remains a `Decision Needed` item (see [Persistence.md](Persistence.md)).
* **Do not assume continuous connectivity** — the data model and sync design must allow core workflows when Supabase is unreachable.
* **Derived data is calculated** — values such as recipe availability or missing ingredients should usually be computed from authoritative sources, not stored as authoritative database truth unless reviewed and justified.
* **User-confirmed commits** — suggested, imported, scanned, or AI-assisted data becomes durable only after user confirmation.
* **Conceptual first** — prefer entity groups and conceptual fields over early overfitting of SQL, RLS policies, or package-specific schemas.

## 4. Domain Ownership and Data Ownership

Persisted data ownership must match domain ownership:

| Data category | Owning domain |
| :--- | :--- |
| Pantry item records, quantities, storage locations, freshness, stock status | Pantry |
| Recipe records, ingredients, instructions, notes, labels, folders, favorites, ratings, version history | Recipes |
| Shopping list records, shopping items, purchase status, priorities, notes, shopping history | Shopping |
| Meal plan records, planned meals, completion status, skipped meals, meal history | Meal Planning |
| Timer records, measurement preferences, cooking utility state (when persistence is needed) | Cooking Assistance Tools |
| Application settings, defaults, onboarding status, personalization preferences | User Preferences |

Ownership rules:

* One domain’s data model must not silently absorb another domain’s authoritative records.
* Cross-domain updates (for example, shopping complete → pantry update) are coordinated by Application / Use Cases; the database stores resulting records for each owning domain.
* Shopping items are **not** the source of truth for pantry inventory.
* Recipe ingredients are **not** the same entity as pantry items unless a reviewed matching strategy explicitly links them.

## 5. Conceptual Entity Groups

The following table summarizes major entity groups. Later sections expand conceptual fields. Names are logical, not final table names.

| Entity group | Owning domain | Purpose |
| :--- | :--- | :--- |
| Pantry item | Pantry | Authoritative household inventory |
| Recipe | Recipes | Saved recipe definitions |
| Recipe ingredient | Recipes | Ingredient requirements belonging to a recipe |
| Recipe organization | Recipes | Folders, labels, favorites, ratings, and related organization |
| Shopping list | Shopping | Container for shopping activity |
| Shopping item | Shopping | Items to purchase and purchase status |
| Shopping history | Shopping | Retained completed shopping activity |
| Meal plan | Meal Planning | Container for scheduled meals |
| Planned meal | Meal Planning | A scheduled meal entry |
| Meal history | Meal Planning | Retained completed or skipped meal outcomes |
| Cooking utility state | Cooking Assistance Tools | Optional persisted timer or measurement preferences |
| User preference | User Preferences | Application and personalization settings |
| Account / household identity | **Decision Needed** | Future account-based and shared-household association |

> **Decision Needed:** Confirm whether early releases model a single-user household only, or whether account and household entities are required from the start for Supabase Auth alignment.

## 6. Pantry-Related Data

Supports DR-1 and pantry functional requirements (FR-9 through FR-14).

### 6.1 Conceptual entity: Pantry item

Authoritative inventory record owned by the Pantry domain.

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Display name | User-facing item name |
| Quantity | Amount currently available |
| Unit | Unit associated with quantity |
| Storage location | For example pantry, refrigerator, freezer |
| Freshness / condition | Conceptual freshness or quality state when used |
| Expiration information | Optional expiration or best-by data |
| Stock status | Normal, low-stock, out-of-stock, or equivalent conceptual status |
| Notes / metadata | Other applicable user metadata |
| Created / updated timestamps | Conceptual audit fields for integrity and future sync |

### 6.2 Conceptual notes

* Stock status may be stored, derived from quantity thresholds, or both. Stored status should not contradict Domain rules.
* Pantry items represent what the household **has**, not what a recipe **needs**.

> **Decision Needed:** Confirm whether stock status is stored as a field, derived from quantity thresholds, or both.

> **TODO:** Define unit representation conventions (canonical units, free-text units, or conversion-aware units) after review.

## 7. Recipe-Related Data

Supports DR-2, DR-3, and recipe functional requirements (FR-15 through FR-21).

### 7.1 Conceptual entity: Recipe

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Title | Recipe name |
| Preparation instructions | Steps or instructions text/structure |
| Serving information | Base servings or yield |
| Notes | User notes |
| Source metadata | Manual entry vs import source identity when applicable |
| Version history | Conceptual support for historical versions or revision records |
| Created / updated timestamps | Conceptual audit fields |

### 7.2 Conceptual entity: Recipe ingredient

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Recipe reference | Owning recipe |
| Ingredient description / name | What the recipe requires |
| Quantity | Required amount for the recipe’s base servings |
| Unit | Unit for the required amount |
| Optional / notes | Optional ingredient flags or notes |
| Optional pantry match reference | Soft link to a pantry item or canonical ingredient, if adopted |

Recipe ingredients belong to the **Recipes** domain. They describe recipe requirements. They are not pantry inventory records.

### 7.3 Conceptual entities: Recipe organization

| Conceptual entity | Notes |
| :--- | :--- |
| Folder / collection | Organizational grouping for recipes |
| Label / tag | Cross-cutting labels |
| Favorite marker | User favorite association |
| Rating | User rating value |

Exact physical modeling (join tables vs embedded fields) is not fixed here.

> **Decision Needed:** Confirm recipe versioning approach (full revision snapshots, append-only history, or lightweight last-N versions).

> **Decision Needed:** Confirm how recipe organization is modeled (folders, labels, both, and membership cardinality).

## 8. Shopping-Related Data

Supports DR-4 and shopping functional requirements (FR-22 through FR-27).

### 8.1 Conceptual entity: Shopping list

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Name / label | Optional list name |
| Status | Active, completed, archived, or equivalent |
| Created / updated / completed timestamps | Conceptual lifecycle fields |

### 8.2 Conceptual entity: Shopping item

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Shopping list reference | Parent list |
| Item description / name | What to purchase |
| Quantity | Desired purchase amount |
| Unit | Unit for quantity |
| Purchase status | Pending, acquired, skipped, or equivalent |
| Priority | Optional priority |
| Notes | User notes |
| Origin metadata | Optional conceptual source such as manual, pantry restock, recipe gap, or meal plan need |
| Optional pantry match reference | Soft link used when confirming inventory updates — not inventory itself |

Shopping items belong to the **Shopping** domain. Completing a shopping item may **inform** pantry updates after user confirmation, but shopping records do not become pantry truth.

### 8.3 Conceptual entity: Shopping history

Completed shopping activities should be retained to support inventory management and recurring suggestions (FR-27).

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Related list or trip reference | Link to completed activity |
| Completed item snapshots | Conceptual record of what was acquired |
| Completion timestamp | When the activity completed |
| Notes / metadata | Other applicable history metadata |

> **Decision Needed:** Confirm whether shopping history stores immutable snapshots, references to completed lists, or both.

## 9. Meal-Planning-Related Data

Supports DR-5 and meal planning functional requirements (FR-28 through FR-33).

### 9.1 Conceptual entity: Meal plan

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Name / label | Optional plan name |
| Time range | Start/end dates or planning period |
| Status | Active, completed, archived, or equivalent |
| Notes | User notes |
| Created / updated timestamps | Conceptual audit fields |

### 9.2 Conceptual entity: Planned meal

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Meal plan reference | Parent plan |
| Scheduled date / slot | Date or time-period assignment |
| Recipe reference and/or free-form meal description | Planned food may reference a recipe or a custom meal entry |
| Completion status | Planned, completed, skipped, or equivalent |
| Notes | User notes |

### 9.3 Conceptual entity: Meal history

Completed meal plans and meal history should be retained for future planning and preferences (FR-33).

| Conceptual field | Notes |
| :--- | :--- |
| Identity | Stable unique identifier |
| Related planned meal or recipe reference | What was cooked or skipped |
| Outcome | Completed or skipped |
| Outcome timestamp | When the outcome was recorded |
| Notes / metadata | Other applicable history metadata |

Recipe availability for planned meals should be calculated from pantry + recipe requirements unless a reviewed caching decision says otherwise.

> **Decision Needed:** Confirm whether a planned meal may exist without a recipe reference (free-form meals only), recipe-only, or both.

## 10. Cooking Tools Data

Cooking Assistance Tools primarily provide runtime utilities (timers, conversions, scaling). Persistence is optional and should remain light.

| Conceptual entity / data | When useful |
| :--- | :--- |
| Measurement preference defaults | Persist preferred units when needed |
| Timer presets or last-used durations | Persist only if required for user continuity |
| Ephemeral running timer state | Usually interface state; persist only if recovery after restart is required |

> **Decision Needed:** Confirm which cooking-tool state, if any, must survive app restarts in early releases.

## 11. User Preferences Data

Supports DR-6.

| Conceptual field | Notes |
| :--- | :--- |
| Identity / scope | User or household preference set |
| Application preferences | Display, sorting, and related defaults |
| Organization preferences | Default organization behavior |
| Default units | Preferred measurement system or units |
| Onboarding status | Whether guided onboarding is complete |
| Personalization preferences | Other applicable preference data |
| Updated timestamp | Conceptual audit field |

Preferences influence presentation and planning support. They do not redefine Pantry, Recipes, Shopping, or Meal Planning ownership.

## 12. Relationships Between Major Entities

Logical relationships (conceptual, not committed FK DDL):

```text
Recipe 1──* RecipeIngredient
Recipe *──* Folder / Label (organization associations)
Recipe 1──* PlannedMeal (optional reference)
MealPlan 1──* PlannedMeal
ShoppingList 1──* ShoppingItem

PantryItem     ← soft match → RecipeIngredient
PantryItem     ← soft match → ShoppingItem
RecipeIngredient → informs missing items → ShoppingItem (workflow, not ownership transfer)
ShoppingItem   → after confirmation → updates PantryItem (workflow)
PlannedMeal / Recipe → after confirmation → updates PantryItem (workflow)
```

Key relationship rules:

* Soft match links are optional association aids. They do not collapse distinct entities into one table/type without review.
* Cross-domain writes are workflow outcomes, not cascade rules owned by the database.

## 13. Ingredient Matching Considerations

Matching connects recipe needs and shopping intent to pantry inventory without merging those concepts.

Matching goals:

* determine whether a recipe ingredient is covered by current pantry inventory
* identify missing ingredients for shopping
* optionally improve restock targeting when shopping completes

Matching challenges:

* naming differences (“cilantro” vs “coriander”)
* unit differences and conversions
* packaging vs usable quantity
* optional ingredients and substitutions

> **Decision Needed:** Choose an ingredient matching strategy (exact name match, normalized canonical ingredient identity, user-assisted linking, fuzzy match with confirmation, or staged combination).

> **TODO:** Document approved matching rules and any canonical ingredient catalog after the strategy decision.

Until then, treat match links as optional non-authoritative associations.

## 14. Recipe Ingredient vs Pantry Item Distinction

| Aspect | Recipe ingredient | Pantry item |
| :--- | :--- | :--- |
| Owning domain | Recipes | Pantry |
| Meaning | What a recipe **requires** | What the household **has** |
| Lifetime | Tied to recipe definition / version | Tied to inventory state |
| Quantity meaning | Required amount (for servings) | Available amount |
| Authoritative for inventory? | No | Yes |

Do **not** make recipe ingredients and pantry items the same persisted entity unless clearly justified and approved.

> **Decision Needed:** Confirm that recipe ingredients and pantry items remain distinct entities with optional matching links (recommended default for this draft).

## 15. Shopping Item vs Pantry Item Distinction

| Aspect | Shopping item | Pantry item |
| :--- | :--- | :--- |
| Owning domain | Shopping | Pantry |
| Meaning | What the user intends to **buy** | What the household **has** |
| Purchase status | Shopping concern | Not inventory truth by itself |
| After purchase | May inform a pantry update after confirmation | Updated only through Pantry-owned records |

Shopping items are **not** the source of truth for pantry inventory.

## 16. History and Audit-Style Data

History supports learning, recurring suggestions, and user continuity without replacing current authoritative state.

| History type | Owning domain | Conceptual role |
| :--- | :--- | :--- |
| Shopping history | Shopping | Retained completed shopping activity and acquired-item context |
| Meal history | Meal Planning | Retained completed or skipped meal outcomes |
| Recipe version history | Recipes | Retained prior recipe definitions or revisions |
| Generic audit timestamps | All domains | Created/updated (and optionally deleted-at) conceptual fields |

History records should generally be append-oriented once finalized. Exact immutability and retention policy remain open.

> **Decision Needed:** Confirm retention and privacy expectations for shopping and meal history (keep forever, time-bounded retention, or user-controlled deletion).

## 17. Local Storage and Supabase/PostgreSQL Data Model Considerations

### 17.1 Chosen remote stack

**Supabase/PostgreSQL** is the chosen backend and remote database stack for account-based and cloud-backed data. Physical schema design for remote storage should target PostgreSQL concepts suitable for Supabase hosting, without committing SQL migration scripts in this document.

Related services:

* Supabase Auth — identity and access for account-based features
* Supabase Storage — file/media storage for optional features (for example recipe images later)

### 17.2 Local storage role

Local storage is required for offline-capable workflows and may hold cached data, drafts, offline views/edits, queued changes, and temporary continuity when Supabase is unavailable.

Local storage is **not** assumed to be the primary source of truth.

### 17.3 Dual-model caution

Until source-of-truth is decided:

* conceptual entities above should remain implementable in both remote PostgreSQL and a future local store
* Domain models should not depend on provider-specific row shapes
* temporary offline drafts or queues may need additional local-only records that are not yet authoritative remote state

> **Decision Needed:** Define the source-of-truth and sync relationship between local storage and Supabase/PostgreSQL.

> **Decision Needed:** Choose the initial on-device persistence technology for Flutter (aligned with [Persistence.md](Persistence.md)).

> **TODO:** After source-of-truth is approved, document whether local and remote schemas are mirrored, subsetted, or intentionally divergent.

## 18. Future Sync Metadata Considerations

Prepare for future sync without committing a final sync design ([System_Architecture.md](../../START_HERE/System_Architecture.md) Section 6.6 and [Persistence.md](Persistence.md) Section 11).

Conceptual metadata that may be needed later:

* stable record identities that survive device boundaries
* updated-at timestamps
* optional version or revision counters
* optional deleted-at / soft-delete markers
* optional device or origin identifiers
* optional sync status for queued offline changes

Do **not** implement sync behavior, conflict resolution, or required sync columns until reviewed.

> **Decision Needed:** Choose a future synchronization strategy and conflict-resolution approach.

> **TODO:** Add approved sync metadata fields to the physical model after sync strategy review.

## 19. Data Integrity Constraints (Conceptual)

Integrity expectations come from QR-11 through QR-14 and persistence guidance. At the data-model level:

* every durable user-managed record has a stable identity
* required domain relationships remain valid (for example, a recipe ingredient belongs to a recipe)
* confirmed user actions produce durable stored changes
* related multi-domain updates remain consistent with Application coordination outcomes
* derived calculated values are not treated as competing authoritative inventory or recipe definitions
* soft deletes, if used, must not resurrect contradictory active records without review

Physical UNIQUE, CHECK, and foreign-key choices should follow these conceptual constraints later, without putting Domain workflow rules into database triggers as a substitute for Application logic.

> **Decision Needed:** Confirm soft-delete vs hard-delete policy for pantry, recipes, shopping, and meal-planning records.

> **TODO:** Define concrete integrity constraints and migration policy when the first physical schema is proposed.

## 20. What This Document Does Not Define

This document does **not** define:

| Topic | Defined in / deferred to |
| :--- | :--- |
| Product requirements or functional behavior | [Product_Specification.md](../../START_HERE/Product_Specification.md) |
| Layer and domain architecture | [System_Architecture.md](../../START_HERE/System_Architecture.md) |
| Repository interfaces, offline access strategy, local-remote sync policy | [Persistence.md](Persistence.md) |
| Coding conventions and folder placement for models/adapters | [Development_Standards.md](Development_Standards.md) |
| SQL migrations, CREATE TABLE scripts, indexes, or RLS policies | Future implementation / review |
| Supabase project setup, Auth wiring, or Storage buckets | Future implementation / review |
| Dart entity classes, Riverpod providers, or repository implementations | Future implementation |
| Final conflict-resolution algorithm | [Decision_Log.md](Decision_Log.md) after review |
| AI automation privacy and confirmation rules | [AI_Guidelines.md](AI_Guidelines.md) |

## 21. Decisions That Still Need Human Review

| Marker | Item |
| :--- | :--- |
| Decision Needed | Account / household modeling for early Supabase Auth alignment |
| Decision Needed | Whether pantry stock status is stored, derived, or both |
| Decision Needed | Recipe versioning approach |
| Decision Needed | Recipe organization model (folders, labels, cardinality) |
| Decision Needed | Shopping history snapshot vs reference model |
| Decision Needed | Whether planned meals may be recipe-linked, free-form, or both |
| Decision Needed | Which cooking-tool state must persist across restarts |
| Decision Needed | Ingredient matching strategy |
| Decision Needed | Confirm recipe ingredients and pantry items remain distinct entities (recommended default) |
| Decision Needed | History retention and privacy expectations |
| Decision Needed | Source-of-truth and sync relationship between local storage and Supabase/PostgreSQL |
| Decision Needed | Initial on-device persistence technology for Flutter |
| Decision Needed | Future synchronization strategy and conflict resolution |
| Decision Needed | Soft-delete vs hard-delete policy |
| TODO | Define unit representation conventions |
| TODO | Document approved ingredient matching rules / canonical catalog after strategy decision |
| TODO | Document local vs remote schema relationship after source-of-truth decision |
| TODO | Add approved sync metadata fields after sync strategy review |
| TODO | Define concrete integrity constraints and migration policy for first physical schema |

## 22. Related Documents

* [Product_Specification.md](../../START_HERE/Product_Specification.md)
* [System_Architecture.md](../../START_HERE/System_Architecture.md)
* [START_HERE.md](../../START_HERE/START_HERE.md)
* [Persistence.md](Persistence.md)
* [Development_Standards.md](Development_Standards.md)
* [Decision_Log.md](Decision_Log.md)
* [AI_Guidelines.md](AI_Guidelines.md)
* [Roadmap.md](Roadmap.md)
