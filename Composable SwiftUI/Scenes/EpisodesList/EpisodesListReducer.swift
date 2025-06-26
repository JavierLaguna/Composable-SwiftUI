import ComposableArchitecture

@Reducer
struct EpisodesListReducer {

    @ObservableState
    struct State: Equatable {
        var episodes: [Episode]
    }

    enum Action {

    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }
}

// MARK: Builder
extension EpisodesListReducer {

    static func build() -> EpisodesListReducer {
        EpisodesListReducer()
    }
}
