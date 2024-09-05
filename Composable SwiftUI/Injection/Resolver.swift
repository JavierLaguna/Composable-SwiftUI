import Foundation
import ComposableArchitecture
import Resolver

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        registerDatasources()
        registerRepositories()
        registerInteractors()

        registerMainModule()
        registerCharactersListModule()
        registerMatchBuddyModule()
    }
}
