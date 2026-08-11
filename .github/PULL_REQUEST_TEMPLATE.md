## Summary

One or two sentences describing what this PR does and why. Link the issue: `Fixes #` or `Relates to #`.

## How

High-level approach. For trivial changes, a one-liner is fine.

## Testing

- [ ] Full test suite: `xcodebuild -project "Composable SwiftUI.xcodeproj" -scheme "Composable SwiftUITests" -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test`
- [ ] Targeted tests: `xcodebuild -project "Composable SwiftUI.xcodeproj" -scheme "Composable SwiftUITests" -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:"Composable SwiftUITests/<SuiteName>" test`
- [ ] Strict lint passes: `swiftlint --strict`
- [ ] New or updated tests written

## Risk & Rollback

What could break and how to revert. If this PR is safe to roll back by reverting the merge commit, say so.

## Checklist

- [ ] Conventional Commits — commits are structured as `type(scope): subject`
- [ ] Work units — each commit is a reviewable logical unit (tests + code + docs stay together)
- [ ] Swift 6 language mode clean — no `@unchecked Sendable`, no `@preconcurrency`
- [ ] User-facing copy in `Composable SwiftUI/Resources/en.lproj/Localizable.strings` if applicable
- [ ] PR under 400 changed lines, or split into chained PRs
- [ ] Architecture boundaries preserved: Scenes → Business ← Data (no downward dependencies)

## Screenshots / Recordings

<!-- Drag or paste screenshots here. For UI changes, include before/after. -->
