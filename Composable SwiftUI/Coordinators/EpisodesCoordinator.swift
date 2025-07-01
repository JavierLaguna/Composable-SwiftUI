import SwiftUI
import ComposableArchitecture

final class EpisodesCoordinator: Coordinator<EpisodesCoordinator.Routes, EpisodesCoordinator.Sheet> {
    // Intentionally empty
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
                store: Store(
                    initialState: .init(),
                    reducer: { EpisodesListReducer.build() }
                ),
                coordinator: self
            )

        case .episodeDetail(let episode):
            EpisodeDetailView(episode: episode)
        }
    }
}

// MARK: Sheets
extension EpisodesCoordinator {

    enum Sheet: Hashable {
        // Intentionally empty
    }
}

// MARK: EpisodesListView.Coordinatable
extension EpisodesCoordinator: EpisodesListView.Coordinatable {

    func onSelect(episode: Episode) {
        push(.episodeDetail(episode))
    }
}
