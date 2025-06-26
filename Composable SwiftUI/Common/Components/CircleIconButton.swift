import SwiftUI

struct CircleIconButton: View {

    let icon: String
    let isActive: Bool
    let isDisabled: Bool
    let action: () -> Void

    init(
        icon: String,
        isActive: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.isActive = isActive
        self.isDisabled = isDisabled
        self.action = action
    }

    private var backgroundColorForState: Color {
        if isDisabled {
            Theme.Colors.background.opacity(0.3)
        } else if isActive {
            Theme.Colors.primary.opacity(0.2)
        } else {
            Theme.Colors.background
        }
    }

    private var iconColorForState: Color {
        isDisabled ? Theme.Colors.primary.opacity(0.3) : Theme.Colors.primary
    }

    private var strokeColorForState: Color {
        if isDisabled {
            Theme.Colors.primary.opacity(0.2)
        } else if isActive {
            Theme.Colors.primary
        } else {
            Theme.Colors.primary.opacity(0.6)
        }
    }

    var body: some View {
        Button(action: isDisabled ? {} : action) {
            Circle()
                .fill(backgroundColorForState)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColorForState)
                        .font(.system(size: 20, weight: .medium))
                )
                .overlay(
                    Circle()
                        .stroke(
                            strokeColorForState,
                            lineWidth: 2
                        )
                )
        }
        .scaleEffect(isDisabled ? 1.0 : (isActive ? 1.1 : 1.0))
        .animation(.spring(response: 0.3), value: isActive && !isDisabled)
        .buttonStyle(PressableButtonStyle())
        .disabled(isDisabled)
    }
}

#Preview {
    CircleIconButton(icon: "play.fill") {
        print("button pressed - normal")
    }

    CircleIconButton(icon: "play.fill", isActive: true) {
        print("button pressed - active")
    }

    CircleIconButton(icon: "play.fill", isDisabled: true) {
        print("button pressed - disabled")
    }
}
