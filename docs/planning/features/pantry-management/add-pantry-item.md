# Add a Pantry Item

## Feature Area

Pantry Management

## User Story

As a home cook, I want to add a pantry item with a name and quantity so that I can start tracking what I have on hand.

## Goal

Give users a simple way to record food and kitchen items in their pantry. This is the foundation for inventory tracking, meal suggestions, and shopping list features later.

## Acceptance Criteria

- The user can open a form to add a new pantry item.
- The user must enter an item name before saving.
- The user can enter a quantity (for example, `2` or `1 lb`).
- After saving, the new item appears in the pantry list.
- If the user tries to save without a name, the app shows a clear error message.
- The user can cancel adding an item without saving changes.

## Notes

- Keep the first version simple. Only name and quantity are required; other fields can come in later stories.
- Future improvements: storage location, expiration date, food type, and out-of-stock status (see other stories in `pantry-management/`).
- This story does not need recipe or shopping list integration to be useful on its own.
