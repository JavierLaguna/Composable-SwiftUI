import ComposableArchitecture
import Resolver
import XCTest

extension Resolver {

    static var test: Resolver!

    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(child: .main)
        Resolver.root = Resolver.test

        Resolver.test.register(AnySchedulerOf<DispatchQueue>.self, name: "main") { _ in
            .immediate
        }
        
        registerMockDatasources()
        registerMockRepositories()
        registerMockInteractors()
        
        registerTestEnvironments()
    }

    static func tearDown() {
        Resolver.root = Resolver.main
    }
}
