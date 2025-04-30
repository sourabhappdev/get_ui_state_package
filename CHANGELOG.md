## 0.0.6

* Fix pub.dev not displaying repository and issue tracker:
  - Updated `repository`, `homepage`, and `issue_tracker` URLs in `pubspec.yaml` to point to the correct `dev` branch.

## 0.0.4

* Enforce `GlobalUiStateConfig` initialization before using `UiStateBuilder`.
  - Added `isInitialized` flag to track initialization status.
  - Added assertion in `UiStateBuilder` constructor to prevent misuse.
* Improved documentation and inline comments for better developer experience.
* Enhanced type safety and structure of `GlobalUiStateConfig` getters.
* Added support for per-screen override widgets with fallback to global config.

## 0.0.3

* Fix logo not visible in `README.md` due to incorrect image URL.

## 0.0.2

* Update `description` in `pubspec.yaml` to meet search engine visibility standards.
* Fix code formatting using Dart formatter.
* Fix unreachable URLs in `pubspec.yaml`:
  - `homepage`
  - `repository`
  - `issue_tracker`
* Add new professional logo to enhance branding.
  - Logo placed at the top of the `README.md`.
