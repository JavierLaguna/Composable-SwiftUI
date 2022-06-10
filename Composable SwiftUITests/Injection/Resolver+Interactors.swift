import Resolver

@testable import Composable_SwiftUI

extension Resolver {

    static func registerMockInteractors() {
        Resolver.test.register { GetCharactersInteractorMock() as GetCharactersInteractor }
        Resolver.test.register { GetBeerBuddyInteractorMock() as GetBeerBuddyInteractor }
    }
}
