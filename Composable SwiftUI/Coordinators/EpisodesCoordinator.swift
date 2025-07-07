import SwiftUI
import ComposableArchitecture

final class EpisodesCoordinator: Coordinator<EpisodesCoordinator.Routes, EpisodesCoordinator.Sheet> {

    @MainActor
    private let episodesListStore: StoreOf<EpisodesListReducer> = Store(
        initialState: .init(),
        reducer: { EpisodesListReducer.build() }
    )
}

// MARK: Routes
extension EpisodesCoordinator {

    enum Routes: Hashable {
        case root
        case episodeDetail(Episode)
    }

    @MainActor
    @ViewBuilder
    func view(for route: Routes) -> some View {
        switch route {
        case .root:
            EpisodesListView(
                store: episodesListStore,
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
extension EpisodesCoordinator {

    enum Sheet: Hashable, View {
        case characterDetail(Character)

        // MARK: View
        var body: some View {
            switch self {
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
extension EpisodesCoordinator: EpisodesListView.Coordinatable {

    func onSelect(episode: Episode) {
        push(.episodeDetail(episode))
    }
}

// MARK: EpisodeDetailView.Coordinatable
extension EpisodesCoordinator: EpisodeDetailView.Coordinatable {

    func onSelect(character: Character) {
        present(.characterDetail(character))
    }
}
