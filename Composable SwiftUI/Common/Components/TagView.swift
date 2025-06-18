import SwiftUI

struct TagView: View {

    let text: String
    let icon: Image?

    init(text: String, icon: Image? = nil) {
        self.text = text
        self.icon = icon
    }

    var body: some View {
        HStack(spacing: Theme.Space.s) {
            if let icon {
                icon
            }

            Text(text)
        }
        .chipStyle()
        .padding(.horizontal, Theme.Space.l)
        .padding(.vertical, Theme.Space.m)
        .background(
            Capsule()
                .fill(Theme.Colors.primary.opacity(0.2))
                .overlay(
                    Capsule()
                        .stroke(Theme.Colors.primary, lineWidth: 1)
                )
        )
        .foregroundColor(Theme.Colors.primary)
    }
}

#Preview {
    TagView(text: "Hello")
    TagView(text: "With Icon", icon: Image(systemName: "star.fill"))
}
