import SwiftUI

struct CardStyle: ViewModifier {

    let padding: CGFloat

    init(padding: CGFloat = Theme.Space.l) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.Colors.backgroundSecondary)
            .clipShape(RoundedRectangle(
                cornerRadius: Theme.Radius.m,
                style: .continuous
            ))
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: Theme.Radius.m,
                    style: .continuous
                )
                .stroke(
                    Color.gray.opacity(0.2),
                    lineWidth: 0.5
                )
            )
    }
}

extension View {

    func cardStyle(padding: CGFloat = Theme.Space.l) -> some View {
        modifier(CardStyle(padding: padding))
    }
}
