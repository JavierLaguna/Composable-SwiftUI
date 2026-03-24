import SwiftUI

struct LoadingAppleIntelligence: View {

    private let text: String?

    init(text: String? = nil) {
        self.text = text
    }

    var body: some View {
        VStack(spacing: Theme.Space.m) {
            KeyframeAnimator(initialValue: 0.0, repeating: true) { rotation in
                Image(systemName: "apple.intelligence")
                    .font(.largeTitle)
                    .rotationEffect(.init(degrees: rotation))

            } keyframes: { _ in
                LinearKeyframe(0, duration: 0)
                LinearKeyframe(360, duration: 5)
            }

            if let text {
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    LoadingAppleIntelligence()

    LoadingAppleIntelligence(text: "Generating with AI...")
}
