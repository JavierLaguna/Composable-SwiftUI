import ComposableArchitecture

@Reducer
struct MainReducer {

    private let charactersListReducer = CharactersListReducer.build()

    @ObservableState
    struct State: Equatable {
        var charactersListState = CharactersListReducer.State()
    }

    enum Action {
        case charactersListActions(CharactersListReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.charactersListState, action: \.charactersListActions) {
            charactersListReducer
        }
        Reduce { _, _ in
            .none
        }
    }
}
