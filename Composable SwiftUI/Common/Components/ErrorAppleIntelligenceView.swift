import SwiftUI

struct ErrorAppleIntelligenceView: View {

    private let text: String

    init(text: String) {
        self.text = text
    }

    init(error: any Error) {
        self.text = error.localizedDescription
    }

    var body: some View {
        VStack(spacing: Theme.Space.m) {
            Image(systemName: "apple.intelligence.badge.xmark")
                .font(.largeTitle)

            Text(text)
                .font(.caption)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ErrorAppleIntelligenceView(text: "text error")

    ErrorAppleIntelligenceView(error: AppleIntelligenceNotAvailableError.deviceNotEligible)
}
