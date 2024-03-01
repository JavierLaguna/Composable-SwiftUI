import ComposableArchitecture
import Resolver

@Reducer
struct MatchBuddyReducer {

    @Injected var getBeerBuddyInteractor: GetBeerBuddyInteractor

    @ObservableState
    struct State: Equatable {
        var beerBuddy: StateLoadable<BeerBuddy> = StateLoadable()
    }

    enum Action {
        case getBeerBuddy(of: Character)
        case onGetBeerBuddy(TaskResult<BeerBuddy?>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .getBeerBuddy(let character):
                state.beerBuddy.state = .loading

                return .run { send in
                    await send(.onGetBeerBuddy(TaskResult {
                        try await getBeerBuddyInteractor.execute(character: character)
                    }))
                }

            case let .onGetBeerBuddy(.success(response)):
                if let beerBuddy = response {
                    state.beerBuddy.state = .populated(data: beerBuddy)
                } else {
                    state.beerBuddy.state = .empty
                }

                return .none

            case let .onGetBeerBuddy(.failure(error)):
                state.beerBuddy.state = .error(error)
                return .none
            }
        }
    }
}
