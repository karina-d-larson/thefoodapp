# CI/CD Pipeline — The Home Cook

## Scope

This pipeline supports **The Home Cook**, a Flutter app for pantry management, recipes, meal planning, and shopping lists. The intended production stack is:

- **Flutter** (web target for CI/CD and GitHub Pages)
- **Riverpod** for state management
- **Supabase** for backend services
- **PostgreSQL** through Supabase
- **Supabase Auth**
- **Supabase Storage**

The workflow file lives at [`.github/workflows/home-cook-ci-cd.yml`](../../.github/workflows/home-cook-ci-cd.yml).

## Pipeline Link

After the workflow is pushed to GitHub and runs at least once, paste the live Actions URL here:

[GitHub Actions Pipeline](https://github.com/karina-d-larson/thefoodapp/actions/workflows/home-cook-ci-cd.yml)

## What the Pipeline Does

The workflow runs on **pull requests into `main`** and **pushes to `main`**.

### CI job (`Lint, Test, Build`)

| Step | Command | Purpose |
| :--- | :--- | :--- |
| Checkout | `actions/checkout@v4` | Load repository source |
| Set up Flutter | `subosito/flutter-action@v2` (stable) | Install Flutter SDK |
| Install dependencies | `flutter pub get` | Resolve Dart/Flutter packages |
| Check formatting | `dart format --output=none --set-exit-if-changed .` | Enforce consistent Dart style |
| Static analysis | `flutter analyze` | Lint and catch analysis issues |
| Unit/widget tests | `flutter test` | Run tests in `test/` |
| Linux desktop target | `flutter create --platforms=linux .` | Generate a temporary Linux runner for integration tests |
| Linux dependencies | `apt-get install ninja-build libgtk-3-dev xvfb` | Headless desktop test dependencies |
| Integration tests | `xvfb-run -a flutter test integration_test -d linux` | Run e2e tests in `integration_test/` |
| Build web | `flutter build web --release --base-href /thefoodapp/` | Produce deployable web output |
| Zip artifact | `zip -r the-home-cook-web-build.zip build/web` | Package build output |
| Upload artifact | `actions/upload-artifact@v4` | Store zip for download from Actions |

### Deploy job (`Deploy to GitHub Pages`)

Runs **only on pushes to `main`** after the CI job succeeds.

| Step | Purpose |
| :--- | :--- |
| Rebuild Flutter Web | Produce a fresh `build/web` for release |
| Configure Pages | Prepare GitHub Pages deployment |
| Upload Pages artifact | Send `build/web` to GitHub Pages |
| Deploy to GitHub Pages | Publish the app at `https://karina-d-larson.github.io/thefoodapp/` |

Pull requests run the full CI job but **do not deploy**.

## Assignment Requirements Mapping

| Assignment requirement | How the pipeline satisfies it |
| :--- | :--- |
| Build project | `flutter build web --release --base-href /thefoodapp/` |
| Lint project | `dart format --output=none --set-exit-if-changed .` and `flutter analyze` |
| Test project | `flutter test` (widget/unit tests in `test/`) |
| Run e2e tests | `flutter test integration_test -d linux` (Linux desktop target generated in CI) |
| Zip build artifacts | `zip -r the-home-cook-web-build.zip build/web` |
| Release artifacts | Uploaded GitHub Actions artifact + GitHub Pages deploy on `main` |
| Submit pipeline link | Use the GitHub Actions workflow URL above |

## AI Agent Workflow

An AI coding agent (Cursor) was asked to:

1. Replace the earlier Node/Vite/React workflow with a **Flutter-based** pipeline matching the real stack.
2. Add a minimal Flutter app shell with **Riverpod** and **Supabase** dependencies declared for future use.
3. Create starter **widget** and **integration** tests themed around pantry, recipes, and meal planning.
4. Configure artifact upload and **GitHub Pages** deployment for `build/web`.
5. Document what the pipeline does, how it maps to assignment requirements, verification performed, and any limitations.
6. Avoid committing secrets and remove incorrect Node/Vite CI scaffolding.

## Verification Performed

Local verification on the development machine:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build web --release --base-href /thefoodapp/
```

Integration tests (`flutter test integration_test -d linux`) require a desktop target and are expected to pass in GitHub Actions after the workflow is pushed. They were not run locally on Windows because Flutter Web does not support `integration_test` device runs yet, and local Windows desktop setup hit an SDK permission issue.

## Blockers and Limitations

| Topic | Status |
| :--- | :--- |
| Supabase initialization | Not wired in `main.dart` yet. CI does not need Supabase credentials for the current starter app and tests. |
| Supabase Auth / Storage / PostgreSQL | Declared in `pubspec.yaml` for the intended stack; feature implementation is future work. |
| Integration tests | Minimal starter in `integration_test/home_cook_app_test.dart`. Flutter Web does not support `integration_test` device runs yet, so CI generates a temporary Linux desktop target and runs tests headlessly with `xvfb-run`. |
| GitHub Pages | Repository **Settings → Pages → Source** must be set to **GitHub Actions** before deploy succeeds. |
| Live pipeline link | The workflow URL is included above; a successful run badge/link should be confirmed after the first push. |
| Mobile targets | CI builds and deploys **Flutter Web** only. Android/iOS builds are out of scope for this workflow. |

## Secrets and Professionalism

**No secrets are committed to this repository.**

- No Supabase URL, anon key, or service role key is stored in source files.
- No database passwords or `.env` files with credentials are checked in.
- `.gitignore` excludes `.env` and `.env.*`.
- When Supabase is integrated, use **GitHub Secrets** (for example `SUPABASE_URL`, `SUPABASE_ANON_KEY`) and inject them only in CI or runtime environments that need them.

## Local Commands

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter test integration_test -d linux
flutter build web --release --base-href /thefoodapp/
```

## Related Files

| File | Role |
| :--- | :--- |
| `pubspec.yaml` | Flutter dependencies (Riverpod, Supabase) |
| `lib/main.dart` | App entry point and starter UI |
| `test/widget_test.dart` | Widget/unit tests |
| `integration_test/home_cook_app_test.dart` | Integration (e2e) test |
| `.github/workflows/home-cook-ci-cd.yml` | CI/CD workflow |
