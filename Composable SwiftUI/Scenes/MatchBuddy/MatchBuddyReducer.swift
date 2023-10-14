import ComposableArchitecture
import Resolver

typealias MatchBuddyStore = Store<MatchBuddyReducer.State, MatchBuddyReducer.Action>

struct MatchBuddyReducer: Reducer {

    @Injected var getBeerBuddyInteractor: GetBeerBuddyInteractor

    struct State: Equatable {
        var beerBuddy: StateLoadable<BeerBuddy> = StateLoadable()
    }

    enum Action: Equatable {
        case getBeerBuddy(of: Character)
        case onGetBeerBuddy(TaskResult<BeerBuddy?>)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
