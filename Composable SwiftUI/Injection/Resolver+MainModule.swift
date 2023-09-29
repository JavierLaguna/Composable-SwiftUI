import ComposableArchitecture
import Resolver

extension Resolver {
    
    static func registerMainModule() {
        register { MainReducer.State() }
            .scope(.application)
        
        register {
            Store<MainReducer.State, MainReducer.Action>(
                initialState: resolve(),
                reducer: {
                    MainReducer()
                }
            )
        }
        .scope(.application)
    }
}
