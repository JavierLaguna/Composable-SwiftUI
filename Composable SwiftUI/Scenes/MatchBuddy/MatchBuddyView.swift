import SwiftUI
import ComposableArchitecture
import Kingfisher

struct MatchBuddyView: View {

    @Environment(CharactersCoordinator.self)
    private var charactersCoordinator

    private let store: StoreOf<MatchBuddyReducer>
    private let character: Character

    init(
        store: StoreOf<MatchBuddyReducer>,
        character: Character
    ) {
        self.store = store
        self.character = character
    }

    @ViewBuilder var emptyView: some View {
        VStack(spacing: Theme.Space.xxl) {
            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                .resizable()
                .frame(width: 70, height: 60)
                .foregroundColor(Theme.Colors.primary)

            Text(R.string.localizable.matchBuddyNotFound().uppercased())
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.title2)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    @ViewBuilder
    private func infoView(title: String, value: String?, isLoading: Bool) -> some View {
        VStack(alignment: .leading, spacing: Theme.Space.m) {
            Text(title)
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.title2)

            Text(value)
                .foregroundColor(Theme.Colors.text)
                .font(Theme.Fonts.body)
                .skeleton(with: isLoading)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(spacing: Theme.Space.l) {
                    KFImage(URL(string: character.image)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(30)

                    Text(character.name)
                        .foregroundColor(Theme.Colors.text)
                        .font(Theme.Fonts.body)
                }

                Spacer()

                Button(action: {
                    charactersCoordinator.showBeerBuddyInfo()

                }, label: {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(Theme.Colors.navIcon)
                })
                .padding(.top, Theme.Space.xxxl)

                Spacer()

                Button(action: {
                    if let buddy = store.beerBuddy.data?.buddy {
                        charactersCoordinator.showBeerBuddyCharacterDetail(character: buddy)
                    }

                }, label: {
                    VStack(spacing: Theme.Space.l) {
                        KFImage(URL(string: store.beerBuddy.data?.buddy.image ?? ""))
                            .resizable()
                            .skeleton(with: store.beerBuddy.isLoading)
                            .shape(type: .rectangle)
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(30)

                        Text(store.beerBuddy.data?.buddy.name)
                            .foregroundColor(Theme.Colors.text)
                            .font(Theme.Fonts.body)
                    }
                })
            }
            .padding(.leading, Theme.Space.xxxl)
            .padding(.trailing, Theme.Space.xxxl)
            .padding(.bottom, -80)
            .offset(y: -80)
            .background(Theme.Colors.background)

            VStack(alignment: .leading, spacing: Theme.Space.xxl) {
                if store.beerBuddy.isEmpty {

                    emptyView

                } else {
                    infoView(
                        title: R.string.localizable.matchBuddyLocation(),
                        value: character.location.name,
                        isLoading: store.beerBuddy.isLoading
                    )

                    infoView(
                        title: R.string.localizable.matchBuddyEpisodesTogether(),
                        value: String(store.beerBuddy.data?.count ?? 0),
                        isLoading: store.beerBuddy.isLoading
                    )

                    infoView(
                        title: R.string.localizable.matchBuddyFirstTimeTogether(),
                        value: store.beerBuddy.data?.firstEpisode.date,
                        isLoading: store.beerBuddy.isLoading
                    )

                    infoView(
                        title: R.string.localizable.matchBuddyLastTimeTogether(),
                        value: store.beerBuddy.data?.lastEpisode.date,
                        isLoading: store.beerBuddy.isLoading
                    )
                }
            }
            .padding(Theme.Space.xxxl)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Theme.Colors.background)
        }
        .padding(.top, 60)
        .background {
            R.image.ic_background_2.image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .sheet(isPresented: charactersCoordinator.sheetIsPresented) {
            charactersCoordinator.sheet
        }
        .task {
            store.send(.getBeerBuddy(of: character))
        }
    }
}

#Preview {
    let store: StoreOf<MatchBuddyReducer> = Store(
        initialState: .init(),
        reducer: {
            MatchBuddyReducer.build()
        }
    )

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

    return MatchBuddyView(
        store: store,
        character: character
    )
    .allEnvironmentsInjected
}
