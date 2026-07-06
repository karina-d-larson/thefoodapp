const featureAreas = [
  'Pantry Management',
  'Recipe Library',
  'Meal Planning',
  'Shopping List',
]

function App() {
  return (
    <main className="app">
      <h1>The Home Cook</h1>
      <p>
        Your kitchen companion for pantry tracking, recipes, and meal planning.
      </p>
      <section aria-label="Core feature areas">
        <h2>Core Feature Areas</h2>
        <ul>
          {featureAreas.map((feature) => (
            <li key={feature}>{feature}</li>
          ))}
        </ul>
      </section>
    </main>
  )
}

export default App
