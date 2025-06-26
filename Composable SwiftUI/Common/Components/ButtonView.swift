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
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                }

                Text(title.uppercased())
                    .font(Theme.Fonts.Special.button)
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
        .buttonStyle(PressableButtonStyle())
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
