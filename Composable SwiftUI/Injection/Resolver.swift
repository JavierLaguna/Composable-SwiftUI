import Foundation
import ComposableArchitecture
import Resolver

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        registerInteractors()

        registerMainModule()
        registerCharactersListModule()
        registerMatchBuddyModule()
    }
}
