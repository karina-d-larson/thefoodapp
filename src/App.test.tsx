import { render, screen, within } from '@testing-library/react'
import App from './App'

describe('The Home Cook pantry dashboard', () => {
  it('shows the app title', () => {
    render(<App />)

    expect(
      screen.getByRole('heading', { name: /the home cook/i }),
    ).toBeInTheDocument()
  })

  it('lists pantry, recipe, and meal planning areas', () => {
    render(<App />)

    const featureList = screen.getByRole('list')

    expect(within(featureList).getByText(/pantry management/i)).toBeInTheDocument()
    expect(within(featureList).getByText(/recipe library/i)).toBeInTheDocument()
    expect(within(featureList).getByText(/meal planning/i)).toBeInTheDocument()
  })
})
