import SwiftUI
import Kingfisher

struct NeighborsCellView: View {

    private let character: Character

    init(character: Character) {
        self.character = character
    }

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
                .font(Theme.Fonts.body)
                .foregroundColor(Theme.Colors.secondaryText)
                .shadow(radius: Theme.Radius.xl)
                .padding(.bottom, Theme.Space.s)
        }
    }
}

#Preview {
    let location = CharacterLocation(id: 1, name: "Earth")
    let character = Character(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        type: "",
        gender: .male,
        origin: location,
        location: location,
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episodes: []
    )

    return NeighborsCellView(character: character)
        .previewLayout(.sizeThatFits)
        .padding()
}
