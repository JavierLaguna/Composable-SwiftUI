import ComposableArchitecture
import Resolver

let mainReducer = Reducer<MainState, MainAction, MainEnvironment>.combine(
    .init { _, _, _ in
        return .none
    },
    charactersListReducer.pullback(
        state: \.charactersList,
        action: /MainAction.charactersList,
        environment: { _ in
            Resolver.resolve()
        }
    ),
    matchBuddyReducer.pullback(
        state: \.matchBuddyState,
        action: /MainAction.matchBuddy,
        environment: { _ in
            Resolver.resolve()
        }
    )
)
