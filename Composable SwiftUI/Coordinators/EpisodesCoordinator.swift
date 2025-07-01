import SwiftUI
import ComposableArchitecture

final class EpisodesCoordinator: Coordinator<EpisodesCoordinator.Routes, EpisodesCoordinator.Sheet> {

    func navigateToEpisodeDetail(episode: Episode) {
        push(.episodeDetail(episode))
    }
}

// MARK: Routes
extension EpisodesCoordinator {

    enum Routes: Hashable, View {
        case root
        case episodeDetail(Episode)

        // MARK: View
        var body: some View {
            switch self {
            case .root:
                EpisodesListView(store: Store(
                    initialState: .init(),
                    reducer: {
                        EpisodesListReducer.build()
                    }
                ))

            case .episodeDetail(let episode):
                EpisodeDetailView(episode: episode)
            }
        }
    }
}

// MARK: Sheets
extension EpisodesCoordinator {

    enum Sheet: Hashable {}
}
