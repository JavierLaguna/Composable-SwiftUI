import Foundation
import ComposableArchitecture
import Resolver

struct CharactersListEnvironment {
    @Injected(name: "main") var mainQueue: AnySchedulerOf<DispatchQueue>
    @Injected var getCharactersInteractor: GetCharactersInteractor
}
