import ComposableArchitecture

let matchBuddyReducer: Reducer<MatchBuddyState, MatchBuddyAction, MatchBuddyEnvironment> = .init { state, action, environment in
    switch action {
    case .getBeerBuddy(let character):
        state.beerBuddy.state = .loading

        return environment.getBeerBuddyInteractor
            .execute(character: character)
            .eraseToEffect()
            .catchToEffect()
            .map(MatchBuddyAction.onGetBeerBuddy)

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
