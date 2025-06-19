import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    
    @State private var isAnimating = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed || isAnimating ? 0.93 : 1.0)
            .animation(.spring(response: 0.30, dampingFraction: 0.45), value: configuration.isPressed || isAnimating)
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        triggerTapAnimation()
                    }
            )
    }
    
    private func triggerTapAnimation() {
        withAnimation(.spring(response: 0.30, dampingFraction: 0.45)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.30, dampingFraction: 0.45)) {
                isAnimating = false
            }
        }
    }
}
