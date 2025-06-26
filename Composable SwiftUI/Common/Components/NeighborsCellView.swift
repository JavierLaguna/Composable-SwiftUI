import SwiftUI
import Kingfisher

struct NeighborsCellView: View {

    let character: Character

    var body: some View {
        VStack {
            Rectangle()
                .fill(Theme.Colors.primary)
                .frame(width: 120, height: 120)
                .cornerRadius(Theme.Radius.xl, corners: [.topLeft, .bottomRight])
                .shadow(radius: Theme.Radius.xl)
                .overlay {
                    KFImage(URL(string: character.image))
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(Theme.Radius.xl, corners: [.topLeft, .bottomRight])
                        .padding(Theme.Space.m)
                }

            Text(character.name)
                .font(Theme.Fonts.Special.body)
                .foregroundColor(Theme.Colors.secondaryText)
                .shadow(radius: Theme.Radius.xl)
                .padding(.bottom, Theme.Space.l)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    NeighborsCellView(character: Character.mock)
        .padding()
}
