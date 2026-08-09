# AGENTS.md

## Cursor Cloud specific instructions

**Project:** "The Home Cook" — a Flutter web app for pantry, recipes, and meal planning (Riverpod + Supabase declared for future use). Entry point is `lib/main.dart`. The standard build/lint/test/run commands are documented in [`docs/ci-cd-pipeline.md`](docs/ci-cd-pipeline.md) — use that as the source of truth rather than duplicating it here.

### Environment
- The Flutter SDK is installed at `$HOME/flutter` and its `bin/` is on `PATH` via `~/.bashrc`. If `flutter` is not found in a non-login shell, invoke it as `$HOME/flutter/bin/flutter`.
- The startup update script runs `flutter pub get`; you do not need to run it manually at session start.

### Running the app (dev)
- Web dev server: `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`, then open `http://localhost:8080/`. The Flutter engine boots for a few seconds before the UI renders (a brief blank screen is normal).

### Lint / test / build
- Lint: `dart format --output=none --set-exit-if-changed .` and `flutter analyze`.
- Unit/widget tests: `flutter test`.
- Web build: `flutter build web --release --base-href /thefoodapp/`.

### Integration tests (non-obvious)
- Flutter Web does not support `integration_test` device runs, so integration tests run against a generated **Linux desktop** target (mirroring CI):
  1. `flutter create --platforms=linux .` (generates an untracked `linux/` target; this is expected and should not be committed).
  2. `xvfb-run -a flutter test integration_test -d linux`.
- Gotcha: if the Linux build fails with a CMake install error where `CMAKE_INSTALL_PREFIX` defaulted to `/usr/local` ("Permission denied"), it is a stale build cache — run `flutter clean` and retry.
- Gotcha: the Linux build links C++ via `clang`, which selects `gcc-14`, so `libstdc++-14-dev` must be present (already installed in the base environment). A `cannot find -lstdc++` error means that dev package is missing.

### Repo note
- The committed `node_modules/` and `dist/` directories are leftover Node/Vite scaffolding from before the project migrated to Flutter. They are not part of the current app and can be ignored for setup, running, and testing.
