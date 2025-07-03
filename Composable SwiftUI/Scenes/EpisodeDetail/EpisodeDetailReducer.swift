import ComposableArchitecture

@Reducer
struct EpisodeDetailReducer {

    let getCharactersInteractor: any GetCharactersInteractor

    @ObservableState
    struct State: Equatable {
        let episode: Episode
        var characters: StateLoadable<[Character]> = .init()
    }

    enum Action {
        case onAppear

        case getEpisodeCharacters
        case onReceiveEpisodeCharacters(Result<[Character], any Error>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.getEpisodeCharacters)

            case .getEpisodeCharacters:
                state.characters.state = .loading
                let ids = state.episode.characters

                return .run { send in
                    await send(.onReceiveEpisodeCharacters(Result { try await getCharactersInteractor.execute(ids: ids)
                    }))
                }

            case .onReceiveEpisodeCharacters(.success(let characters)):
                state.characters.state = .populated(data: characters)
                return .none

            case .onReceiveEpisodeCharacters(.failure(let error)):
                state.characters.state = .error(error)
                return .none
            }
        }
    }
}

// MARK: Builder
extension EpisodeDetailReducer {

    static func build() -> EpisodeDetailReducer {
        EpisodeDetailReducer(
            getCharactersInteractor: GetCharactersInteractorFactory.build()
        )
    }
}
