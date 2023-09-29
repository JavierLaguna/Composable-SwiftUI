import ComposableArchitecture
import Resolver

typealias CharactersListStore = Store<CharactersListReducer.State, CharactersListReducer.Action>

struct CharactersListReducer: Reducer {
    
    @Injected var getCharactersInteractor: GetCharactersInteractor
    
    struct State: Equatable {
        @BindingState var searchText = ""
        var characters: StateLoadable<[Character]> = StateLoadable()
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case getCharacters
        case onGetCharacters(TaskResult<[Character]>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$searchText):
                return .none
                
            case .binding:
                return .none
                
            case .getCharacters:
                state.characters.state = .loading
                
                return .run { send in
                    await send(.onGetCharacters(TaskResult {
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

// MARK: State Computed properties
extension CharactersListReducer.State {
    
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
