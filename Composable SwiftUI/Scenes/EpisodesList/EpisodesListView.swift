import SwiftUI
import ComposableArchitecture

struct EpisodesListView: View {

    let store: StoreOf<EpisodesListReducer>

    var episodes: [Episode] {
        store.episodes.data ?? [] // TODO: JLI - FIX
    }

    var body: some View {
        Group {
            switch store.episodes.state {
            case .loading, .initial:
                FullScreenLoadingView()

            case .populated(let episodes):
                EpisodesList(episodes: episodes)

            case .error(let error):
                ErrorView(
                    error: error,
                    onRetry: {
                        store.send(.getEpisodes)
                    }
                )
                .padding(.horizontal, Theme.Space.xxl)

            default:
                EmptyView()
            }
        }
        .background(BackgroundPatternPrimaryView())
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle(R.string.localizable.episodesListTitle())
        .environment(store)
        .task {
            store.send(.onAppear)
        }
    }
}

private struct EpisodesList: View {

    @Environment(StoreOf<EpisodesListReducer>.self)
    private var store

    let episodes: [Episode]

    var body: some View {
        List {
            ForEach(episodes) { episode in
                EpisodeCellView(episode: episode)
                    .padding(.bottom, episode == episodes.last ? Theme.Space.tabBarHeight : 0)
                    .onAppear {
                        if episode == episodes.last {
                            store.send(.getMoreEpisodes)
                        }
                    }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(
                vertical: Theme.Space.m,
                horizontal: Theme.Space.xxl
            ))
        }
        .listStyle(.plain)
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
