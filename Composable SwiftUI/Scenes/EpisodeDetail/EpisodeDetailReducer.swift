import ComposableArchitecture

@Reducer
struct EpisodeDetailReducer {

    let getCharactersInteractor: any GetCharactersInteractor
    let getEpisodeDescriptionInteractor: any GetEpisodeDescriptionInteractor

    @ObservableState
    struct State: Equatable {
        let episode: Episode
        var characters: StateLoadable<[Character]> = .init()
        var episodeDescription: StateLoadable<String> = .init()
    }

    enum Action {
        case onAppear

        case getEpisodeCharacters
        case onReceiveEpisodeCharacters(Result<[Character], any Error>)

        case getEpisodeDescription
        case onReceiveEpisodeDescription(Result<String, any Error>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .send(.getEpisodeCharacters),
                    .send(.getEpisodeDescription)
                )

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

            case .getEpisodeDescription:
                state.episodeDescription.state = .loading
                let episode = state.episode

                return .run { send in
                    await send(.onReceiveEpisodeDescription(Result { try await getEpisodeDescriptionInteractor.execute(episode: episode)
                    }))
                }

            case .onReceiveEpisodeDescription(.success(let description)):
                state.episodeDescription.state = .populated(data: description)
                return .none

            case .onReceiveEpisodeDescription(.failure(let error)):
                state.episodeDescription.state = .error(error)
                return .none
            }
        }
    }
}

// MARK: Builder
extension EpisodeDetailReducer {

    static func build() -> EpisodeDetailReducer {
        EpisodeDetailReducer(
            getCharactersInteractor: GetCharactersInteractorFactory.build(),
            getEpisodeDescriptionInteractor: GetEpisodeDescriptionInteractorFactory.build()
        )
    }
}
