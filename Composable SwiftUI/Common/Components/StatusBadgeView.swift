import SwiftUI

struct StatusBadgeView: View {

    let status: CharacterStatus

    @ViewBuilder
    private var statusIcon: some View {
        switch status {
        case .alive: Image(systemName: "heart.fill")
        case .dead: Image(systemName: "xmark")
        case .unknown: Image(systemName: "questionmark")
        }
    }

    private var statusColor: Color {
        switch status {
        case .alive: Color(red: 0.24, green: 0.86, blue: 0.52)
        case .dead: Color.red
        case .unknown: Color.yellow
        }
    }

    var body: some View {
        HStack(spacing: Theme.Space.m) {
            statusIcon
                .foregroundColor(Color.black)
                .font(.system(size: 14))

            Text(status.rawValue.uppercased())
                .font(.custom("Impact", size: 12)) // TODO: JLI
                .fontWeight(.black)
        }
        .padding(.horizontal, Theme.Space.xl)
        .padding(.vertical, Theme.Space.m)
        .background(statusColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.black.opacity(0.2), lineWidth: 2)
        )
    }
}

#Preview {
    StatusBadgeView(status: .alive)
    StatusBadgeView(status: .dead)
    StatusBadgeView(status: .unknown)
}
