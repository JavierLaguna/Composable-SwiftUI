import ComposableArchitecture

@Reducer
struct CharacterDetailReducer {

    let getCharacterInteractor: any GetCharacterInteractor
    let getTotalCharactersCountInteractor: any GetTotalCharactersCountInteractor
    let getEpisodesByIdsInteractor: any GetEpisodesByIdsInteractor

    @ObservableState
    struct State: Equatable {
        var currentCharacter: StateLoadable<Character>
        var totalCharactersCount: Int = 0
        var episodes: StateLoadable<[Episode]> = .init()

        var canSeePreviousCharacter: Bool {
            (currentCharacter.data?.id ?? 0) > 1
        }

        var canSeeNextCharacter: Bool {
            (currentCharacter.data?.id ?? 0) < totalCharactersCount
        }

        init(character: Character) {
            currentCharacter = .init(state: .populated(data: character))
        }
    }

    enum Action {
        case getTotalCharactersCount
        case onGetTotalCharactersCount(TaskResult<Int>)

        case getEpisodes
        case onGetEpisodes(TaskResult<[Episode]>)

        case seePreviousCharacter
        case seeNextCharacter
        case onReceiveNewCharacter(TaskResult<Character>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .getTotalCharactersCount:
                return .run { send in
                    await send(.onGetTotalCharactersCount(TaskResult {
                        try await getTotalCharactersCountInteractor.execute()
                    }))
                }

            case .onGetTotalCharactersCount(.success(let totalCharactersCount)):
                state.totalCharactersCount = totalCharactersCount
                return .none

            case .onGetTotalCharactersCount(.failure):
                return .none

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
                guard state.canSeePreviousCharacter,
                      let currentCharacter = state.currentCharacter.data else {
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
                guard state.canSeeNextCharacter,
                    let currentCharacter = state.currentCharacter.data else {
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

    static func build() -> CharacterDetailReducer {
        CharacterDetailReducer(
            getCharacterInteractor: GetCharacterInteractorFactory.build(),
            getTotalCharactersCountInteractor: GetTotalCharactersCountInteractorFactory.build(),
            getEpisodesByIdsInteractor: GetEpisodesByIdsInteractorFactory.build()
        )
    }
}
