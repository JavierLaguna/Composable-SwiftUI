import ComposableArchitecture

@Reducer
struct MainReducer {

    private let charactersListReducer = CharactersListReducer.build()
    private let matchBuddyReducer = MatchBuddyReducer.build()

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
            charactersListReducer
        }
        Scope(state: \.matchBuddyState, action: \.matchBuddyActions) {
            matchBuddyReducer
        }
        Reduce { _, _ in
            .none
        }
    }
}
