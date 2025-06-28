import Observation
import SwiftUI
import ComposableArchitecture

@Observable
final class EpisodesCoordinator {

    private(set) var path: [Routes] = []

    @MainActor
    var pathBinding: Binding<[Routes]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
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
