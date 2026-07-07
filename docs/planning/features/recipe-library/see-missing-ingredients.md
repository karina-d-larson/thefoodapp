# See Missing Ingredients on a Recipe

## Feature Area

Recipe Library

## User Story

As a home cook, I want to see which ingredients from a recipe I am missing in my pantry so that I know what I still need to buy or substitute.

## Goal

Connect the recipe library and pantry in a simple, helpful way. When viewing a recipe, the user should quickly see what they already have and what they still need.

## Acceptance Criteria

- When viewing a recipe, the user can see a list of all ingredients for that recipe.
- Each ingredient is marked as either **in pantry** or **missing**, based on a simple name match with pantry items.
- If an ingredient is in the pantry but quantity is unknown or zero, the app treats it as missing or shows a clear warning (pick one behavior and apply it consistently).
- The user can understand the difference between in-pantry and missing items at a glance (for example, with labels or icons — not color alone).
- If the pantry is empty, all ingredients are shown as missing.
- If the recipe has no ingredients, the app shows a helpful empty state instead of an error.

## Notes

- Depends on: users being able to add pantry items and create recipes with ingredients.
- Keep matching simple for the first version (for example, match by ingredient name). Fuzzy matching and unit conversion can come later.
- Future improvements: add all missing ingredients to the shopping list in one tap, show partial matches, account for recipe serving size.
- Do not include AI-based ingredient recognition or barcode scanning in this story.
