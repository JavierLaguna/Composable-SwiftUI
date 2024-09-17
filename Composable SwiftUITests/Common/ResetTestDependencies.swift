import Resolver

class ResetTestDependencies {

    init() {
        Resolver.resetUnitTestRegistrations()
    }

    deinit {
        Resolver.tearDown()
    }
}
