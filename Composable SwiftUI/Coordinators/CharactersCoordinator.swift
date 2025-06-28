import Observation
import SwiftUI
import ComposableArchitecture

@Observable
final class CharactersCoordinator {

    private let mainStore: StoreOf<MainReducer>

    private(set) var path: [Routes] = []

    @MainActor
    var pathBinding: Binding<[Routes]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    private(set) var sheet: Sheet?

    @MainActor
    var sheetIsPresented: Binding<Bool> {
        Binding(
            get: { self.sheet != nil },
            set: { self.sheet = $0 ? self.sheet : nil }
        )
    }

    init(mainStore: StoreOf<MainReducer>) {
        self.mainStore = mainStore
    }

    func navigateToCharacterDetail(character: Character) {
        path.append(.characterDetail(character))
    }

    func navigateToBeerBuddy(character: Character) {
        path.append(.beerBuddy(character))
    }

    func navigateToNeighbors(character: Character) {
        path.append(.neighbors(character))
    }

    func navigateEpisodesList(episodes: [Episode]) {
        path.append(.episodes(episodes))
    }

    func showBeerBuddyInfo() {
        sheet = .beerBuddyInfo
    }

    func showBeerBuddyCharacterDetail(character: Character) {
        sheet = .beerBuddyCharacterDetail(character)
    }
}

// MARK: Routes
extension CharactersCoordinator {

    enum Routes: Hashable, View {
        case root(StoreOf<MainReducer>)
        case characterDetail(Character)
        case beerBuddy(Character)
        case neighbors(Character)
        case episodes([Episode])

        // MARK: View
        var body: some View {
            switch self {
            case .root(let mainStore):
                let store = mainStore.scope(
                    state: \.charactersListState,
                    action: \.charactersListActions
                )
                CharactersListView(store: store)

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
                EpisodesListView(store: Store(
                    initialState: .init(
                        episodes: episodes
                    ),
                    reducer: {
                        EpisodesListReducer.build()
                    }
                ))
            }
        }
    }
}

// MARK: Sheets
extension CharactersCoordinator {

    enum Sheet: Hashable, View {
        case beerBuddyInfo
        case beerBuddyCharacterDetail(Character)

        // MARK: View
        var body: some View {
            switch self {
            case .beerBuddyInfo:
                MatchBuddyInfoView()

            case .beerBuddyCharacterDetail(let character):
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
