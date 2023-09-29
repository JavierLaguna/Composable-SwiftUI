import ComposableArchitecture
import Resolver

extension Resolver {
    
    static func registerMatchBuddyModule() {
        register(MatchBuddyStore.self, name: "scoped") { _ in
            let mainStore: MainStore = resolve()
            
            return mainStore.scope(state: \.matchBuddyState, action: MainReducer.Action.matchBuddyActions)
        }
    }
}
