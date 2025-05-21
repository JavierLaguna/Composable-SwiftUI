import SwiftUI
import ComposableArchitecture
import Kingfisher

struct CharacterDetailView: View {

    let store: StoreOf<CharacterNeighborsReducer>
    var character: Character

    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading, spacing: Theme.Space.l) {
                    KFImage(URL(string: character.image))
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))

                    HStack {
                        Text(character.name)
                            .foregroundColor(Theme.Colors.text)
                            .font(Theme.Fonts.title)

                        Spacer()

                        CharacterStatusCapsule(status: character.status)
                    }
                    .padding(.top, Theme.Space.xxl)

                    HStack {
                        Image(systemName: "flag.fill")
                            .font(.title2)

                        Text(character.origin.name)
                            .font(Theme.Fonts.subtitle)
                    }
                    .foregroundColor(Theme.Colors.text)

                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)

                        Text(character.location.name)
                            .font(Theme.Fonts.subtitle)
                    }
                    .foregroundColor(Theme.Colors.text)

                    Text(character.gender.localizedDescription)
                        .font(Theme.Fonts.subtitle)

                    Text(character.type)
                        .font(Theme.Fonts.subtitle)

                    Text(character.species)
                        .font(Theme.Fonts.subtitle)
                }
                .padding()
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .padding()

            Spacer()
        }
        .background {
            R.image.ic_background_2.image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .navigationTitle(Text(character.name)
            .foregroundColor(Theme.Colors.text)
            .font(Theme.Fonts.title))
        .navigationBarTitleDisplayMode(.automatic)
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

    return NavigationStack {
        CharacterDetailView(
            store: Store(
                initialState: .init(
                    locationDetail: .init(state: .loading)
                ),
                reducer: {
                    CharacterNeighborsReducer.build(locationId: 1)
                }
            ),
            character: character
        )
    }
}
