import ComposableArchitecture
import Resolver

extension Resolver {
    
    static func registerMatchBuddyModule() {
        register {
            MatchBuddyEnvironment()
        }
        .scope(.cached)

        register(Store<MatchBuddyState, MatchBuddyAction>.self, name: "scoped") { _ in
            let mainStore: Store<MainState, MainAction> = resolve()

            return mainStore.scope(state: \.matchBuddyState, action: MainAction.matchBuddy)
        }
    }
}
