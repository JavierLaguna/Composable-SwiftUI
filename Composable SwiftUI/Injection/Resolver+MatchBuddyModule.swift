import ComposableArchitecture
import Resolver

extension Resolver {

    static func registerMatchBuddyModule() {
        register(StoreOf<MatchBuddyReducer>.self, name: "scoped") { _ in
            let mainStore: StoreOf<MainReducer> = resolve()

            return mainStore.scope(
                state: \.matchBuddyState,
                action: \.matchBuddyActions
            )
        }
    }
}
