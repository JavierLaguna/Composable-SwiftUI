import SwiftUI
import ComposableArchitecture

struct EpisodesListView: View {

    let store: StoreOf<EpisodesListReducer>

    var body: some View {
        List {
            ForEach(store.episodes) { episode in
                EpisodeCellView(episode: episode)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(
                vertical: Theme.Space.m,
                horizontal: Theme.Space.none
            ))
        }
        .listStyle(.plain)
        .background(BackgroundPatternSecondaryView())
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle(R.string.localizable.episodesListTitle())
    }
}

#Preview {
    NavigationStack {
        EpisodesListView(
            store: Store(
                initialState: .init(
                    episodes: Episode.mocks
                ),
                reducer: {
                    EpisodesListReducer.build()
                }
            )
        )
    }
    .allEnvironmentsInjected
}
