import SwiftUI

struct CharacterStatusCapsule: View {

    let status: CharacterStatus

    private var iconName: String {
        switch status {
        case .alive: "❤️"
        case .dead: "💀"
        case .unknown: "❓"
        }
    }

    private var backgroundColor: Color {
        switch status {
        case .alive: .green
        case .dead: .red
        case .unknown: .secondary
        }
    }

    var body: some View {
        HStack(spacing: Theme.Space.m) {
            Text(status.localizedDescription)
                .font(Theme.Fonts.bodyBold)

            Text(iconName)
        }
        .padding(.horizontal, Theme.Space.l)
        .padding(.vertical, Theme.Space.m)
        .foregroundColor(.white)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}

#Preview {
    CharacterStatusCapsule(status: .alive)
    CharacterStatusCapsule(status: .dead)
    CharacterStatusCapsule(status: .unknown)
}
