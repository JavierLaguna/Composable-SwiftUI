# AGENTS Guide for Composable-SwiftUI
This guide is for coding agents working in this repository.

## Project Context
- iOS app written in Swift + SwiftUI.
- Architecture: Clean Architecture + The Composable Architecture (TCA).
- Project file: `Composable SwiftUI.xcodeproj`.
- App target/scheme: `Composable SwiftUI`.
- Test target/scheme: `Composable SwiftUITests`.
- Test framework: Swift Testing (`import Testing`, `@Suite`, `@Test`).
- CI workflow: `.github/workflows/runTests.yml`.
- CI lanes: `fastlane/Fastfile` (`test`, `generate_coverage_report`).

## Setup
1. Use Xcode 16.x or newer (CI metadata references 16.2).
2. Install Ruby gems:
```bash
bundle install
```
3. Ensure SwiftLint is available.

## Build Commands
Run from repository root.

Build app:
```bash
xcodebuild -project "Composable SwiftUI.xcodeproj" -scheme "Composable SwiftUI" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
```

Build tests target/scheme:
```bash
xcodebuild -project "Composable SwiftUI.xcodeproj" -scheme "Composable SwiftUITests" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
```

## Test Commands
Run all tests with xcodebuild:
```bash
xcodebuild -project "Composable SwiftUI.xcodeproj" -scheme "Composable SwiftUITests" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test
```

Run all tests with Fastlane:
```bash
bundle exec fastlane test
```

Set device for Fastlane scan when required:
```bash
DEVICE='iPhone 16 Pro (18.2)' bundle exec fastlane test
```

### Run a Single Test (important)
Run one test method:
```bash
xcodebuild -project "Composable SwiftUI.xcodeproj" -scheme "Composable SwiftUITests" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -only-testing:"Composable SwiftUITests/CharactersListReducerTests/getCharactersSuccess" test
```

Run one test type/file:
```bash
xcodebuild -project "Composable SwiftUI.xcodeproj" -scheme "Composable SwiftUITests" -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -only-testing:"Composable SwiftUITests/CharactersListReducerTests" test
```

Guidance:
- Prefer `-only-testing:` for local debugging and CI triage.

## Lint, Formatting, and Hooks
Run strict lint:
```bash
swiftlint --strict
```

Auto-fix lint:
```bash
swiftlint --fix --strict
```

Run pre-commit hooks on changed files:
```bash
pre-commit run
```

Run pre-commit hooks on all files:
```bash
pre-commit run --all-files
```

No dedicated SwiftFormat config exists in this repository.
Primary style enforcement is `.swiftlint.yml` + established local patterns.

## Coverage / CI
Generate Sonar-compatible coverage XML:
```bash
bundle exec fastlane generate_coverage_report
```

## Code Style Guidelines

### Imports
- Keep imports minimal and explicit.
- Typical test import order:
  1) `Foundation` when needed
  2) testing frameworks (`Testing`, etc.)
  3) third-party modules (`ComposableArchitecture`, `Mockable`)
  4) `@testable import Composable_SwiftUI` last

### Formatting
- Use 4-space indentation.
- Prefer readable line wraps over dense one-liners.
- Use `// MARK:` blocks in larger files (builders, private helpers, sections).
- Follow `.swiftlint.yml` thresholds for line/type/file lengths.

### Types and Protocols
- Keep protocol boundaries between Business and Data layers.
- Use `any` existential for protocol-typed dependencies.
- Use `Sendable` where concurrency boundaries require it.

### Naming
- `PascalCase` for types, protocols, enums, file names.
- `camelCase` for properties, methods, functions, local vars.
- Common suffixes: `*Reducer`, `*View`, `*Repository`, `*Factory`.

### Architecture and TCA
- Preserve clean layering:
  - Business: entities, repository protocols, interactors.
  - Data: repository implementations, services, mappers.
  - Scenes: reducers, views, coordinators.
- In reducers:
  - side effects go in `.run`
  - keep state transitions explicit and deterministic
  - use `StateLoadable` transitions (`.loading`, `.populated`, `.error`)

### Error Handling
- Do not use force casts or force tries.
- Use `guard` for invalid state/inputs.
- Preserve domain-specific error mapping across layers.
- Map failures to explicit UI/reducer state instead of silent fallbacks.

### Testing
- Use Swift Testing attributes and descriptive names.
- Keep Arrange/Act/Assert structure clear.
- For reducers, use `TestStore` to assert action/state evolution.
- Use `@Mockable` mocks and verify call counts/arguments.

## SwiftLint Priorities
From `.swiftlint.yml` (non-exhaustive):
- `force_cast`: error
- `force_try`: error
- `closure_end_indentation`: error
- trailing whitespace checks enabled
- type and identifier size limits enabled
- multiple opt-in style/performance rules enabled

Run lint before finalizing changes.

## Cursor / Copilot Rules
Checked locations:
- `.cursor/rules/`
- `.cursorrules`
- `.github/copilot-instructions.md`

Current status:
- No Cursor rules found.
- No Copilot instructions file found.
