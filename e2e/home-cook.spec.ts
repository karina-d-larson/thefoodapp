import { test, expect } from '@playwright/test'

test.describe('The Home Cook meal planning shell', () => {
  test('home page shows pantry and recipe feature areas', async ({ page }) => {
    await page.goto('/')

    await expect(
      page.getByRole('heading', { name: 'The Home Cook' }),
    ).toBeVisible()

    const featureList = page.getByRole('list')

    await expect(featureList.getByText('Pantry Management')).toBeVisible()
    await expect(featureList.getByText('Recipe Library')).toBeVisible()
    await expect(featureList.getByText('Meal Planning')).toBeVisible()
  })
})
