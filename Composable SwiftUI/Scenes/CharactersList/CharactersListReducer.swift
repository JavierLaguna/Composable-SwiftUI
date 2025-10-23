import ComposableArchitecture

@Reducer
struct CharactersListReducer {

    let getCharactersInteractor: any GetCharactersInteractor

    @ObservableState
    struct State: Equatable {
        var searchText = ""
        var characters: StateLoadable<[Character]> = StateLoadable()

        var filteredCharacters: [Character]? {
            guard let characters = characters.data else {
                return nil
            }

            guard !searchText.isEmpty else {
                return characters
            }

            return characters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case getCharacters
        case onGetCharacters(Result<[Character], any Error>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.searchText):
                return .none

            case .binding:
                return .none

            case .getCharacters:
                state.characters.state = .loading

                return .run { send in
                    await send(.onGetCharacters(Result {
                        try await getCharactersInteractor.execute()
                    }))
                }

            case let .onGetCharacters(.success(response)):
                var newData = state.characters.data
                newData?.append(contentsOf: response)
                state.characters.state = .populated(data: newData ?? response)
                return .none

            case let .onGetCharacters(.failure(error)):
                state.characters.state = .error(error)
                return .none
            }
        }
    }
}

// MARK: Builder
extension CharactersListReducer {

    static func build() -> CharactersListReducer {
        CharactersListReducer(
            getCharactersInteractor: GetCharactersInteractorFactory.build()
        )
    }
}
