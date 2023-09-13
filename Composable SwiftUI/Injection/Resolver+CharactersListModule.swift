import ComposableArchitecture
import Resolver

extension Resolver {
    
    static func registerCharactersListModule() {
        
        register(Store<CharactersListReducer.State, CharactersListReducer.Action>.self, name: "scoped") { _ in
            let mainStore: Store<MainReducer.State, MainReducer.Action> = resolve()
            
            return mainStore.scope(state: \.charactersListState, action: MainReducer.Action.charactersListActions)
        }
    }
}
