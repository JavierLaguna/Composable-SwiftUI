import ComposableArchitecture
import Resolver

extension Resolver {
    
    static func registerMainModule() {
        register { MainReducer.State() }

        register {
            Store<MainReducer.State, MainReducer.Action>(
                initialState: resolve(),
                reducer: {
                    MainReducer()
                }
            )
        }
    }
}
