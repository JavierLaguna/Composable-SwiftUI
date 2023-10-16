import SwiftUI
import ComposableArchitecture
import Resolver
import Kingfisher

struct MatchBuddyView: View {

    @Injected(name: "scoped") var store: MatchBuddyStore

    @EnvironmentObject private var matchBuddyRouter: MatchBuddyCoordinator.Router

    private var character: Character

    init(character: Character) {
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
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                        matchBuddyRouter.route(to: \.info)
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Theme.Colors.navIcon)
                    })
                    .padding(.top, Theme.Space.xxxl)

                    Spacer()

                    VStack(spacing: Theme.Space.l) {
                        KFImage(URL(string: viewStore.beerBuddy.data?.buddy.image ?? ""))
                            .resizable()
                            .skeleton(with: viewStore.beerBuddy.isLoading)
                            .shape(type: .rectangle)
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(30)

                        Text(viewStore.beerBuddy.data?.buddy.name)
                            .foregroundColor(Theme.Colors.text)
                            .font(Theme.Fonts.body)
                    }
                }
                .padding(.leading, Theme.Space.xxxl)
                .padding(.trailing, Theme.Space.xxxl)
                .padding(.bottom, -80)
                .offset(y: -80)
                .background(Theme.Colors.background)

                VStack(alignment: .leading, spacing: Theme.Space.xxl) {

                    if viewStore.beerBuddy.isEmpty {

                        emptyView

                    } else {
                        infoView(
                            title: R.string.localizable.matchBuddyLocation(),
                            value: character.location.name,
                            isLoading: viewStore.beerBuddy.isLoading
                        )

                        infoView(
                            title: R.string.localizable.matchBuddyEpisodesTogether(),
                            value: String(viewStore.beerBuddy.data?.count ?? 0),
                            isLoading: viewStore.beerBuddy.isLoading
                        )

                        infoView(
                            title: R.string.localizable.matchBuddyFirstTimeTogether(),
                            value: viewStore.beerBuddy.data?.firstEpisode.date,
                            isLoading: viewStore.beerBuddy.isLoading
                        )

                        infoView(
                            title: R.string.localizable.matchBuddyLastTimeTogether(),
                            value: viewStore.beerBuddy.data?.lastEpisode.date,
                            isLoading: viewStore.beerBuddy.isLoading
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
            .task {
                viewStore.send(.getBeerBuddy(of: character))
            }
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

    return MatchBuddyView(character: character)
}
