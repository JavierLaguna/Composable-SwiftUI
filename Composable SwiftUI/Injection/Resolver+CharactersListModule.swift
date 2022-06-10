import ComposableArchitecture
import Resolver

extension Resolver {
    
    static func registerCharactersListModule() {
        register {
            CharactersListEnvironment()
        }
        .scope(.cached)

        register(Store<CharactersListState, CharactersListAction>.self, name: "scoped") { _ in
            let mainStore: Store<MainState, MainAction> = resolve()

            return mainStore.scope(state: \.charactersList, action: MainAction.charactersList)
        }
    }
}
