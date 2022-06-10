import ComposableArchitecture
import Resolver

extension Resolver {
    
    static func registerMainModule() {
        register { MainEnvironment() }
        register { MainState() }

        register {
            Store<MainState, MainAction>(
                initialState: resolve(),
                reducer: mainReducer,
                environment: resolve()
            )
        }
    }
}
