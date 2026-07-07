# Documentation Reorganization Report

> **Generated:** 6 July 2026  
> **Project:** The Home Cook (`thefoodapp`)  
> **Purpose:** Record documentation file moves, new structure, and items needing human review before additional documentation planning.

---

## 1. Current Project Structure Summary

```
/
├── README.md
├── START_HERE/
│   ├── START_HERE.md
│   ├── Product_Specification.md
│   └── System_Architecture.md
├── docs/
│   ├── README.md
│   ├── architecture/
│   │   ├── AI_Guidelines.md
│   │   ├── Database.md
│   │   ├── Decision_Log.md
│   │   ├── Development_Standards.md
│   │   ├── Persistence.md
│   │   └── Roadmap.md
│   ├── design/
│   │   └── README.md
│   ├── planning/
│   │   ├── ci-cd-pipeline.md
│   │   ├── documentation_reorganization_report.md
│   │   ├── documentation_cleanup_report.md
│   │   ├── NOTES.md
│   │   └── features/
│   │       ├── README.md
│   │       ├── pantry-management/
│   │       ├── recipe-library/
│   │       └── shopping-list/
│   └── references/
│       └── _TEMPLATE.md
├── .github/workflows/home-cook-ci-cd.yml
├── lib/
├── test/
├── integration_test/
├── web/
├── pubspec.yaml
└── pubspec.lock
```

### Non-documentation items in the repository

| Path | Type | Notes |
| :--- | :--- | :--- |
| `lib/` | Flutter application code | Left in place |
| `test/` | Widget/unit tests | Left in place |
| `integration_test/` | Integration tests | Left in place |
| `web/` | Flutter web assets | Left in place |
| `.github/workflows/` | CI/CD | Left in place |

> **Update (6 July 2026):** Legacy `node_modules/` and `dist/` artifacts from the earlier Vite/React scaffold were deleted after reorganization. See [documentation_cleanup_report.md](documentation_cleanup_report.md).

---

## 2. Previous Documentation Locations

| Previous path | Description |
| :--- | :--- |
| `docs/PRODUCT_SPECIFICATION.md` | Software Requirements Specification (SRS) |
| `docs/SYSTEM_ARCHITECTURE.md` | System architecture document |
| `docs/NOTES.md` | Temporary documentation and architecture planning notes |
| `docs/_TEMPLATE.md` | Feature implementation plan template |
| `docs/ci-cd-pipeline.md` | CI/CD lab and pipeline documentation |
| `docs/features/` | User story planning folder |
| `docs/README.md` | Minimal repo note (`# thefoodapp`) |
| *(none)* | No root `README.md` existed before this reorganization |

---

## 3. New Documentation Locations

| New path | Role |
| :--- | :--- |
| `README.md` | Short repository entry point |
| `START_HERE/START_HERE.md` | Main documentation map and reading guide |
| `START_HERE/Product_Specification.md` | Authoritative product / SRS document |
| `START_HERE/System_Architecture.md` | Authoritative architecture document |
| `docs/README.md` | Documentation folder index |
| `docs/architecture/` | Architecture support documents |
| `docs/design/` | Design materials (placeholder folder) |
| `docs/planning/` | Planning, lab work, feature stories, temporary notes |
| `docs/references/` | Templates and supporting reference material |

---

## 4. Files Moved

| From | To | Method |
| :--- | :--- | :--- |
| `docs/PRODUCT_SPECIFICATION.md` | `START_HERE/Product_Specification.md` | `git mv` (rename) |
| `docs/SYSTEM_ARCHITECTURE.md` | `START_HERE/System_Architecture.md` | `git mv` (rename) |
| `docs/NOTES.md` | `docs/planning/NOTES.md` | `git mv` |
| `docs/_TEMPLATE.md` | `docs/references/_TEMPLATE.md` | `git mv` |
| `docs/ci-cd-pipeline.md` | `docs/planning/ci-cd-pipeline.md` | `git mv` |
| `docs/features/` (entire folder) | `docs/planning/features/` | `git mv` |

**Content preservation:** All moved files retain their full original content. No merges were required because no target files already existed.

---

## 5. Files Renamed

| Previous name | New name | Notes |
| :--- | :--- | :--- |
| `PRODUCT_SPECIFICATION.md` | `Product_Specification.md` | Naming preference applied during move to `START_HERE/` |
| `SYSTEM_ARCHITECTURE.md` | `System_Architecture.md` | Naming preference applied during move to `START_HERE/` |

---

## 6. Files Copied

No files were copied. All foundational documents were moved once to avoid duplicate authoritative sources.

---

## 7. Files Created

| File | Type | Purpose |
| :--- | :--- | :--- |
| `README.md` | New | Brief root entry point linking to `START_HERE/` |
| `START_HERE/START_HERE.md` | New | Documentation map and reading order |
| `docs/README.md` | Replaced | Documentation index (previous one-line content preserved in Section 2) |
| `docs/architecture/Persistence.md` | Placeholder | Intended persistence documentation |
| `docs/architecture/Database.md` | Placeholder | Intended database documentation |
| `docs/architecture/AI_Guidelines.md` | Placeholder | Intended AI collaboration guidelines |
| `docs/architecture/Development_Standards.md` | Placeholder | Intended development standards |
| `docs/architecture/Roadmap.md` | Placeholder | Intended product/technical roadmap |
| `docs/architecture/Decision_Log.md` | Placeholder | Intended architectural decision log |
| `docs/design/README.md` | Placeholder | Explains purpose of design folder |
| `docs/planning/documentation_reorganization_report.md` | New | This report |

---

## 8. Files Left in Place and Why

| Path | Reason |
| :--- | :--- |
| `.github/workflows/home-cook-ci-cd.yml` | CI/CD configuration, not documentation |
| `lib/`, `test/`, `integration_test/`, `web/` | Application source and tests |
| `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml` | Flutter project configuration |
| `.gitignore` | Repository configuration |

> **Update:** `node_modules/` and `dist/` were later removed as legacy Vite/React artifacts. See [documentation_cleanup_report.md](documentation_cleanup_report.md).

---

## 9. Files That May Be Temporary or Outdated

| File / folder | Why it may be temporary or outdated |
| :--- | :--- |
| `docs/planning/NOTES.md` | Explicitly marked **Temporary planning document** in its own header |
| `docs/planning/ci-cd-pipeline.md` | Lab/implementation documentation; may be consolidated later |
| `docs/planning/features/` | Planning backlog, not authoritative requirements |
| `docs/references/_TEMPLATE.md` | Teacher-provided reference template; intentionally kept — may inform a future Home Cook-specific template |

---

## 10. Files That Need Human Review

| Priority | File / topic | Review question |
| :--- | :--- | :--- |
| **High** | `START_HERE/Product_Specification.md` | Confirm this remains the authoritative SRS after the move |
| **High** | `START_HERE/System_Architecture.md` | Confirm architecture doc is complete and correctly placed |
| **High** | `docs/planning/NOTES.md` | Migrate useful content into permanent docs; decide when to archive or delete |
| **Medium** | `docs/planning/features/README.md` | Confirm `docs/planning/features/` is the right long-term home |
| **Low** | `docs/design/README.md` | Add design materials when available |
| **Low** | `docs/architecture/*.md` placeholders | Next priority — write architecture support document content |

> **Resolved:** Legacy `node_modules/` and `dist/` cleanup is complete. `docs/references/_TEMPLATE.md` is intentionally kept as a teacher-provided reference. See [documentation_cleanup_report.md](documentation_cleanup_report.md).

---

## 11. Broken Links or Links Needing Manual Check

| Location | Link / reference | Status |
| :--- | :--- | :--- |
| `docs/references/_TEMPLATE.md` | `docs/MISSING_FEATURES.md` | **Broken** — target file does not exist in this repository |
| `START_HERE/Product_Specification.md` | Internal table-of-contents anchor links | **Likely OK** — anchors are within the same file |
| `docs/planning/ci-cd-pipeline.md` | `.github/workflows/home-cook-ci-cd.yml` | **Updated** to `../../.github/workflows/home-cook-ci-cd.yml` |
| `docs/planning/features/README.md` | Folder paths in structure diagram | **Updated** to `docs/planning/features/` |
| New placeholder docs | Links to `START_HERE/` and sibling architecture docs | **Should be checked** after additional docs are written |
| External links in `ci-cd-pipeline.md` | GitHub Actions URL | **Should be checked** after next workflow run |

---

## 12. Uncertainties and Assumptions Made

1. **Feature stories belong in planning.** `docs/features/` was moved to `docs/planning/features/` because user stories are planning material, not foundational or architecture-authoritative docs.

2. **NOTES.md belongs in planning.** The file describes itself as temporary planning notes.

3. **`_TEMPLATE.md` is a preserved reference.** It was moved to `docs/references/` because it is a reusable teacher-provided template. The original should be kept; a Home Cook-specific template may be created from it later.

4. **CI/CD doc belongs in planning.** `ci-cd-pipeline.md` documents lab work and pipeline setup, not core product or architecture authority.

5. **No content merging was needed.** No destination files existed before moves, so content was not combined or overwritten.

6. **Legacy Node artifacts were later deleted.** `node_modules/` and `dist/` were removed after reorganization as legacy Vite/React artifacts no longer needed for the Flutter project.

7. **Architecture placeholders only.** New files under `docs/architecture/` are marked placeholders and contain no final technical content.

8. **Root README did not exist.** A new brief `README.md` was created rather than relocating the old `docs/README.md` one-liner.

---

## 13. Recommended Next Documentation Steps

1. **Review foundational docs in `START_HERE/`** and confirm they are current after the Flutter/Supabase stack work.

2. **Migrate content from `docs/planning/NOTES.md`** into the appropriate permanent documents, especially architecture placeholders.

3. **Write architecture support docs** — next documentation priority (placeholders exist; content not yet written):
   - `Persistence.md`
   - `Database.md`
   - `Development_Standards.md`
   - `Decision_Log.md`
   - `Roadmap.md`
   - `AI_Guidelines.md`

4. **Review `docs/planning/NOTES.md`** for migration, archival, or deletion after useful content is moved.

5. **Add design materials** to `docs/design/` when wireframes, brand notes, or UI references are ready.

6. **Update `docs/planning/NOTES.md` hierarchy diagram** if desired — it still references the pre-reorganization layout.

7. **Commit documentation changes** and verify no external bookmarks or assignment links still point to old `docs/PRODUCT_SPECIFICATION.md` or `docs/SYSTEM_ARCHITECTURE.md` paths.

8. **See [documentation_cleanup_report.md](documentation_cleanup_report.md)** for resolved cleanup decisions (`node_modules/`, `dist/`, `_TEMPLATE.md`).

---

## Summary for External Planning Tools

- Foundational docs now live in `START_HERE/`.
- Architecture support docs are scaffolded in `docs/architecture/` as placeholders.
- Planning and feature stories are under `docs/planning/`.
- References/templates are under `docs/references/`.
- No documentation content was deleted.
- One known broken link remains in `_TEMPLATE.md` (reference to `docs/MISSING_FEATURES.md`).
- Legacy `node_modules/` and `dist/` cleanup is complete.
- `_TEMPLATE.md` is intentionally kept as a teacher-provided reference.
- See [documentation_cleanup_report.md](documentation_cleanup_report.md) for follow-up decisions.
