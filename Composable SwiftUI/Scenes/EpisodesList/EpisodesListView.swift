import SwiftUI
import ComposableArchitecture

struct EpisodesListView: View {

    protocol Coordinatable {
        func onSelect(episode: Episode)
    }

    let store: StoreOf<EpisodesListReducer>
    let coordinator: any Coordinatable

    var body: some View {
        Group {
            switch store.episodes.state {
            case .initial,
                    .loading,
                    .populated:

                if let episodes = store.episodes.data {
                    EpisodesList(
                        episodes: episodes,
                        isLoading: store.episodes.isLoading,
                        coordinator: coordinator
                    )

                } else {
                    FullScreenLoadingView()
                }

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
    let isLoading: Bool
    let coordinator: any EpisodesListView.Coordinatable

    var body: some View {
        List {
            Group {
                ForEach(episodes) { episode in
                    Button {
                        coordinator.onSelect(episode: episode)

                    } label: {
                        EpisodeCellView(episode: episode)
                            .onAppear {
                                if episode == episodes.last {
                                    store.send(.getMoreEpisodes)
                                }
                            }
                    }
                    .buttonStyle(PressableButtonStyle())
                }

                if isLoading {
                    HStack {
                        Spacer()
                        LoadingView()
                        Spacer()
                    }
                }

                Color.clear
                    .frame(height: Theme.Space.tabBarHeight)
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
            ),
            coordinator: EpisodesCoordinator()
        )
    }
    .allEnvironmentsInjected
}
