import ComposableArchitecture

typealias MainStore = Store<MainReducer.State, MainReducer.Action>

struct MainReducer: Reducer {
    
    struct State: Equatable {
        var charactersListState = CharactersListReducer.State()
        var matchBuddyState = MatchBuddyReducer.State()
    }
    
    enum Action: Equatable {
        case charactersListActions(CharactersListReducer.Action)
        case matchBuddyActions(MatchBuddyReducer.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.charactersListState, action: /Action.charactersListActions) {
            CharactersListReducer()
        }
        Scope(state: \.matchBuddyState, action: /Action.matchBuddyActions) {
            MatchBuddyReducer()
        }
        Reduce { state, action in
            return .none
        }
      }
}
