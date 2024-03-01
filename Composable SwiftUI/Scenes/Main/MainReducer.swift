import ComposableArchitecture

@Reducer
struct MainReducer {

    @ObservableState
    struct State: Equatable {
        var charactersListState = CharactersListReducer.State()
        var matchBuddyState = MatchBuddyReducer.State()
    }

    enum Action {
        case charactersListActions(CharactersListReducer.Action)
        case matchBuddyActions(MatchBuddyReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.charactersListState, action: \.charactersListActions) {
            CharactersListReducer()
        }
        Scope(state: \.matchBuddyState, action: \.matchBuddyActions) {
            MatchBuddyReducer()
        }
        Reduce { _, _ in
            return .none
        }
    }
}
