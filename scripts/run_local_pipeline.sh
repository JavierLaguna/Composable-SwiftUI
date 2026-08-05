#!/usr/bin/env bash
# Mirrors .github/workflows/runTests.yml locally (macOS + Xcode required).
# Usage: source env.local && ./scripts/run_local_pipeline.sh
set -euo pipefail

# Step: check token (from env.local)
if [[ -z "${SONAR_TOKEN:-}" ]]; then
    echo "❌ SONAR_TOKEN is not set. Run: source env.local (after pasting your token)" >&2
    exit 1
fi

# Step: Set Xcode to Skip Macro Validation (same as workflow)
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# Step: Run Fastlane (same as workflow: DEVICE + retries)
export FASTLANE_XCODEBUILD_SETTINGS_RETRIES=10
DEVICE='iPhone 17 Pro (26.5)' bundle exec fastlane test

# Step: Generate Sonar coverage report
bundle exec fastlane generate_coverage_report

# Step: SonarCloud Scan (same args as workflow)
sonar-scanner \
    -Dsonar.projectKey=JavierLaguna_Composable-SwiftUI \
    -Dsonar.organization=javierlaguna \
    -Dsonar.host.url=https://sonarcloud.io \
    -Dsonar.coverageReportPaths=fastlane/test_output/coverage/sonarqube-generic-coverage.xml \
    -Dsonar.sources=.

echo "✅ Pipeline local completada"
