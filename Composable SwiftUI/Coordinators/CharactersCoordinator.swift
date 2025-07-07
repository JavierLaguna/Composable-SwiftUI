import SwiftUI
import ComposableArchitecture

final class CharactersCoordinator: Coordinator<CharactersCoordinator.Routes, CharactersCoordinator.Sheet> {

    private let mainStore: StoreOf<MainReducer>

    init(mainStore: StoreOf<MainReducer>) {
        self.mainStore = mainStore
    }

    func navigateToCharacterDetail(character: Character) {
        push(.characterDetail(character))
    }

    func navigateToBeerBuddy(character: Character) {
        push(.beerBuddy(character))
    }

    func navigateToNeighbors(character: Character) {
        push(.neighbors(character))
    }

    func navigateToEpisodesList(episodes: [Episode]) {
        push(.episodes(episodes))
    }

    func navigateToEpisodeDetail(episode: Episode) {
        push(.episodeDetail(episode))
    }

    func showBeerBuddyInfo() {
        present(.beerBuddyInfo)
    }

    func showBeerBuddyCharacterDetail(character: Character) {
        present(.characterDetail(character))
    }
}

// MARK: Routes
extension CharactersCoordinator {

    enum Routes: Hashable {
        case root
        case characterDetail(Character)
        case beerBuddy(Character)
        case neighbors(Character)
        case episodes([Episode])
        case episodeDetail(Episode)
    }

    @MainActor
    @ViewBuilder
    func view(for route: Routes) -> some View {
        switch route {
        case .root:
            CharactersListView(store: mainStore.scope(
                state: \.charactersListState,
                action: \.charactersListActions
            ))

        case .characterDetail(let character):
            CharacterDetailView(
                store: Store(
                    initialState: .init(
                        character: character,
                        viewMode: .allInfo
                    ),
                    reducer: {
                        CharacterDetailReducer.build()
                    }
                )
            )

        case .beerBuddy(let character):
            MatchBuddyView(
                store: Store(
                    initialState: .init(),
                    reducer: {
                        MatchBuddyReducer.build()
                    }
                ),
                character: character
            )

        case .neighbors(let character):
            CharacterNeighborsView(
                store: Store(
                    initialState: .init(),
                    reducer: {
                        CharacterNeighborsReducer.build(
                            locationId: character.location.id
                        )
                    }
                )
            )

        case .episodes(let episodes):
            EpisodesListView(
                store: Store(
                    initialState: .init(
                        episodes: episodes
                    ),
                    reducer: {
                        EpisodesListReducer.build()
                    }
                ),
                coordinator: self
            )

        case .episodeDetail(let episode):
            EpisodeDetailView(
                store: Store(
                    initialState: .init(
                        episode: episode
                    ),
                    reducer: {
                        EpisodeDetailReducer.build()
                    }
                ),
                coordinator: self
            )
        }
    }
}

// MARK: Sheets
extension CharactersCoordinator {

    enum Sheet: Hashable, View {
        case beerBuddyInfo
        case characterDetail(Character)

        // MARK: View
        var body: some View {
            switch self {
            case .beerBuddyInfo:
                MatchBuddyInfoView()

            case .characterDetail(let character):
                CharacterDetailView(
                    store: Store(
                        initialState: .init(
                            character: character,
                            viewMode: .basicInfo
                        ),
                        reducer: {
                            CharacterDetailReducer.build()
                        }
                    )
                )
            }
        }
    }
}

// MARK: EpisodesListView.Coordinatable
extension CharactersCoordinator: EpisodesListView.Coordinatable {

    func onSelect(episode: Episode) {
        push(.episodeDetail(episode))
    }
}

// MARK: EpisodeDetailView.Coordinatable
extension CharactersCoordinator: EpisodeDetailView.Coordinatable {

    func onSelect(character: Character) {
        showBeerBuddyCharacterDetail(character: character)
    }
}
