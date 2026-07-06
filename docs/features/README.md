# Feature Stories — The Home Cook

This folder organizes user stories by feature area. Each markdown file is one independently deployable story.

## Folder Structure

```
docs/features/
├── README.md                          ← This file
├── pantry-management/
│   ├── add-pantry-item.md
│   ├── edit-pantry-item.md
│   ├── remove-pantry-item.md
│   ├── update-item-quantity.md
│   ├── track-expiration-date.md
│   ├── mark-item-out-of-stock.md
│   ├── assign-storage-location.md
│   ├── categorize-by-food-type.md
│   ├── view-pantry-list.md
│   ├── filter-by-storage-location.md
│   ├── filter-by-status.md
│   └── sort-by-expiration.md
├── recipe-library/
│   ├── create-recipe.md
│   ├── add-preparation-instructions.md
│   ├── view-recipe-details.md
│   ├── edit-recipe.md
│   ├── delete-recipe.md
│   ├── organize-recipes-into-folders.md
│   ├── add-recipe-notes.md
│   ├── search-recipes.md
│   └── see-missing-ingredients.md
├── meal-planning/
│   ├── create-meal-plan.md
│   ├── add-recipe-to-meal-plan.md
│   ├── view-meal-plan.md
│   ├── edit-or-remove-planned-meals.md
│   ├── suggest-meals-from-pantry.md
│   └── mark-planned-meal-complete.md
├── shopping-list/
│   ├── create-shopping-list.md
│   ├── manually-add-shopping-item.md
│   ├── add-missing-recipe-ingredients.md
│   ├── check-off-purchased-items.md
│   ├── add-low-stock-pantry-items.md
│   ├── edit-or-remove-shopping-items.md
│   └── view-shopping-list-by-status.md
└── user-preferences/
    ├── set-dietary-preferences.md
    ├── set-budget-preferences.md
    ├── set-cooking-skill-level.md
    ├── set-time-preferences.md
    ├── set-household-needs.md
    └── view-and-update-preferences.md
```

## Feature Areas

| Folder | Description |
| :--- | :--- |
| `pantry-management/` | Track food and kitchen items the user has on hand |
| `recipe-library/` | Save, view, and organize recipes |
| `meal-planning/` | Plan upcoming meals and get basic suggestions |
| `shopping-list/` | Build and manage a list of items to buy |
| `user-preferences/` | Personalize how the app works for each user |

## Story File Format

Each story file uses this structure:

- **Story Title** — Short, action-oriented name
- **Feature Area** — Which folder / product area it belongs to
- **User Story** — As a … I want … so that …
- **Goal** — What this story delivers in plain language
- **Acceptance Criteria** — Testable conditions for done
- **Notes** — Dependencies, scope limits, and future improvements

## First-Version Stories (Created)

These four stories form a small, deployable starting slice:

| File | Why it is a good first story |
| :--- | :--- |
| `pantry-management/add-pantry-item.md` | Core data entry; everything else builds on pantry inventory |
| `recipe-library/create-recipe.md` | Lets users save meals they cook regularly |
| `shopping-list/manually-add-shopping-item.md` | Useful on its own, even before recipe integration |
| `recipe-library/see-missing-ingredients.md` | Connects pantry and recipes with clear user value |

## Deferred to Future Stories

The following are intentionally **not** included as first-version stories. They may appear in **Notes** as future improvements only:

- Receipt scanning
- Barcode scanning
- AI image recognition
- Full AI meal planning
- Recipe import from web links (may be noted as a future story in `recipe-library/`)

## Naming Conventions

- Folders use `kebab-case` and match a product feature area.
- Story files use `kebab-case` and describe one user-facing capability.
- One story per file. If a story grows too large, split it into smaller deployable stories.
