import ComposableArchitecture
import Resolver

extension Resolver {

    static var test: Resolver!

    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(child: .main)
        Resolver.root = Resolver.test

        registerMockDatasources()
        registerMockRepositories()
        registerMockInteractors()
    }

    static func tearDown() {
        Resolver.root = Resolver.main
    }
}
