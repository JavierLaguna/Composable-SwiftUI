import ComposableArchitecture

@Reducer
struct CharacterDetailReducer {

    let getCharacterInteractor: any GetCharacterInteractor
    let getEpisodesByIdsInteractor: any GetEpisodesByIdsInteractor
    let character: Character // TODO: JLI ?¿

    @ObservableState
    struct State: Equatable {
        var currentCharacter: StateLoadable<Character>
        var episodes: StateLoadable<[Episode]> = .init()
    }

    enum Action {
        case getEpisodes
        case onGetEpisodes(TaskResult<[Episode]>)

        case seePreviousCharacter
        case seeNextCharacter
        case onReceiveNewCharacter(TaskResult<Character>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .getEpisodes:
                guard let currentCharacter = state.currentCharacter.data else {
                    return .none
                }

                state.episodes.state = .loading

                return .run { send in
                    await send(.onGetEpisodes(TaskResult {
                        try await getEpisodesByIdsInteractor.execute(ids: currentCharacter.episodes)
                    }))
                }

            case .onGetEpisodes(.success(let episodes)):
                state.episodes.state = .populated(data: episodes)
                return .none

            case .onGetEpisodes(.failure(let error)):
                state.episodes.state = .error(error)
                return .none

            case .seePreviousCharacter:
                guard let currentCharacter = state.currentCharacter.data else {
                    return .none
                }

                state.currentCharacter.state = .loading

                let nextCharacterId = currentCharacter.id - 1

                return .run { send in
                    await send(.onReceiveNewCharacter(TaskResult {
                        try await getCharacterInteractor.execute(id: nextCharacterId)
                    }))
                }

            case .seeNextCharacter:
                guard let currentCharacter = state.currentCharacter.data else {
                    return .none
                }

                state.currentCharacter.state = .loading

                let nextCharacterId = currentCharacter.id + 1

                return .run { send in
                    await send(.onReceiveNewCharacter(TaskResult {
                        try await getCharacterInteractor.execute(id: nextCharacterId)
                    }))
                }

            case .onReceiveNewCharacter(.success(let newCharacter)):
                state.currentCharacter.state = .populated(data: newCharacter)
                return .send(.getEpisodes)

            case .onReceiveNewCharacter(.failure(let error)):
                state.currentCharacter.state = .error(error)
                return .none
            }
        }
    }
}

// MARK: Builder
extension CharacterDetailReducer {

    static func build(character: Character) -> CharacterDetailReducer {
        CharacterDetailReducer(
            getCharacterInteractor: GetCharacterInteractorFactory.build(),
            getEpisodesByIdsInteractor: GetEpisodesByIdsInteractorFactory.build(),
            character: character
        )
    }
}
