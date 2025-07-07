import ComposableArchitecture

@Reducer
struct CharacterDetailReducer {

    let getCharactersInteractor: any GetCharactersInteractor
    let getCharacterDescriptionInteractor: any GetCharacterDescriptionInteractor
    let getTotalCharactersCountInteractor: any GetTotalCharactersCountInteractor
    let getEpisodesByIdsInteractor: any GetEpisodesInteractor

    @ObservableState
    struct State: Equatable {
        let viewMode: CharacterDetailViewMode

        var currentCharacter: StateLoadable<Character>
        var totalCharactersCount: Int = 0
        var episodes: StateLoadable<[Episode]> = .init()

        var canSeePreviousCharacter: Bool {
            viewMode == .allInfo &&
            (currentCharacter.data?.id ?? 0) > 1
        }

        var canSeeNextCharacter: Bool {
            viewMode == .allInfo &&
            (currentCharacter.data?.id ?? 0) < totalCharactersCount
        }

        init(
            character: Character,
            viewMode: CharacterDetailViewMode
        ) {
            self.viewMode = viewMode
            currentCharacter = .init(state: .populated(data: character))
        }
    }

    enum Action {
        case onAppear

        case getCharacterDescription
        case onReceiveCharacterDescription(Result<String, any Error>)

        case getTotalCharactersCount
        case onReceiveTotalCharactersCount(Result<Int, any Error>)

        case getEpisodes
        case onReceiveEpisodes(Result<[Episode], any Error>)

        case seePreviousCharacter
        case seeNextCharacter
        case onReceiveNewCharacter(Result<Character, any Error>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.viewMode == .allInfo {
                    return .merge(
                        .send(.getCharacterDescription),
                        .send(.getTotalCharactersCount),
                        .send(.getEpisodes)
                    )

                } else {
                    return .send(.getCharacterDescription)
                }

            case .getCharacterDescription:
                guard let currentCharacter = state.currentCharacter.data else {
                    return .none
                }

                return .run { send in
                    await send(.onReceiveCharacterDescription(Result {
                        try await getCharacterDescriptionInteractor.execute(character: currentCharacter)
                    }))
                }

            case .onReceiveCharacterDescription(.success(let characterDescription)):
                guard let currentCharacter = state.currentCharacter.data else {
                    return .none
                }
                let newCharacter = currentCharacter.withDescription(characterDescription)
                state.currentCharacter.state = .populated(data: newCharacter)
                return .none

            case .onReceiveCharacterDescription(.failure):
                return .none

            case .getTotalCharactersCount:
                return .run { send in
                    await send(.onReceiveTotalCharactersCount(Result {
                        try await getTotalCharactersCountInteractor.execute()
                    }))
                }

            case .onReceiveTotalCharactersCount(.success(let totalCharactersCount)):
                state.totalCharactersCount = totalCharactersCount
                return .none

            case .onReceiveTotalCharactersCount(.failure):
                return .none

            case .getEpisodes:
                guard state.viewMode == .allInfo,
                    let currentCharacter = state.currentCharacter.data else {
                    return .none
                }

                state.episodes.state = .loading

                return .run { send in
                    await send(.onReceiveEpisodes(Result {
                        try await getEpisodesByIdsInteractor.execute(ids: currentCharacter.episodes)
                    }))
                }

            case .onReceiveEpisodes(.success(let episodes)):
                state.episodes.state = .populated(data: episodes)
                return .none

            case .onReceiveEpisodes(.failure(let error)):
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
                    await send(.onReceiveNewCharacter(Result {
                        try await getCharactersInteractor.execute(id: nextCharacterId)
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
                    await send(.onReceiveNewCharacter(Result {
                        try await getCharactersInteractor.execute(id: nextCharacterId)
                    }))
                }

            case .onReceiveNewCharacter(.success(let newCharacter)):
                state.currentCharacter.state = .populated(data: newCharacter)
                return .merge(
                    .send(.getEpisodes),
                    .send(.getCharacterDescription)
                )

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
            getCharactersInteractor: GetCharactersInteractorFactory.build(),
            getCharacterDescriptionInteractor: GetCharacterDescriptionInteractorFactory.build(),
            getTotalCharactersCountInteractor: GetTotalCharactersCountInteractorFactory.build(),
            getEpisodesByIdsInteractor: GetEpisodesInteractorFactory.build()
        )
    }
}
