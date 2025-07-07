import ComposableArchitecture

@Reducer
struct EpisodesListReducer {

    let getEpisodesInteractor: any GetEpisodesInteractor

    @ObservableState
    struct State: Equatable {
        let paginateEpisodes: Bool
        var episodes: StateLoadable<[Episode]>

        init() {
            paginateEpisodes = true
            self.episodes = .init()
        }

        init(episodes: [Episode]) {
            paginateEpisodes = false
            self.episodes = .init(state: .populated(data: episodes))
        }
    }

    enum Action {
        case onAppear
        case getEpisodes
        case getMoreEpisodes
        case onReceiveEpisodes(Result<[Episode], any Error>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .getMoreEpisodes:
                guard state.paginateEpisodes else {
                    return .none
                }

                return .send(.getEpisodes)

            case .getEpisodes:
                state.episodes.state = .loading

                return .run { send in
                    await send(.onReceiveEpisodes(Result { try await getEpisodesInteractor.execute()
                    }))
                }

            case .onReceiveEpisodes(.success(let newEpisodes)):
                var episodes = state.episodes.data
                episodes?.append(contentsOf: newEpisodes)
                state.episodes.state = .populated(data: episodes ?? newEpisodes)
                return .none

            case .onReceiveEpisodes(.failure(let error)):
                state.episodes.state = .error(error)
                return .none
            }
        }
    }
}

// MARK: Builder
extension EpisodesListReducer {

    static func build() -> EpisodesListReducer {
        EpisodesListReducer(
            getEpisodesInteractor: GetEpisodesInteractorFactory.build()
        )
    }
}
