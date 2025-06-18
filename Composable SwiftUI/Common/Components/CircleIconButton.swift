import SwiftUI

struct CircleIconButton: View {

    let icon: String
    let isActive: Bool
    let action: () -> Void

    init(
        icon: String,
        isActive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.isActive = isActive
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(isActive ? Theme.Colors.primary.opacity(0.2) : Theme.Colors.background)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(Theme.Colors.primary)
                        .font(.system(size: 20, weight: .medium))
                )
                .overlay(
                    Circle()
                        .stroke(
                            isActive ? Theme.Colors.primary : Theme.Colors.primary.opacity(0.6),
                            lineWidth: 2
                        )
                )
        }
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(.spring(response: 0.3), value: isActive)
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    CircleIconButton(icon: "play.fill") {
        print("button pressed")
    }

    CircleIconButton(icon: "play.fill", isActive: true) {
        print("button pressed")
    }
}
