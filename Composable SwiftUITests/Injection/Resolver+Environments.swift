import Resolver

@testable import Composable_SwiftUI

extension Resolver {

    static func registerTestEnvironments() {
        Resolver.test.register { CharactersListEnvironment() }
        Resolver.test.register { MatchBuddyEnvironment() }
    }
}
