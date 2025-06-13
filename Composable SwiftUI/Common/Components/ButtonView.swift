import SwiftUI

struct ButtonView: View {

    let title: String
    let icon: String?
    let action: () -> Void

    init(
        title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 12) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                }

                Text(title.uppercased())
                    .font(.custom("Impact", size: 18))
                    .fontWeight(.black)
            }
            .foregroundColor(.black)
            .padding(.horizontal, 32)
            .padding(.vertical, Theme.Space.xl)
            .background(Theme.Colors.buttonBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black.opacity(0.2), lineWidth: 2)
            )
        }
        .buttonStyle(PressableStyle())
    }
}

private struct PressableStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .animation(.spring(response: 0.30, dampingFraction: 0.45), value: configuration.isPressed)
    }
}

#Preview {
    ButtonView(title: "Button", icon: "play.fill") {
        print("button pressed")
    }

    ButtonView(title: "Button") {
        print("button pressed")
    }
}
