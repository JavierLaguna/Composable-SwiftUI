import Resolver

@testable import Composable_SwiftUI

extension Resolver {

    static func registerMockRepositories() {
        Resolver.test.register { CharactersRepositoryMock() as CharactersRepository }
        Resolver.test.register { LocationRepositoryMock() as LocationRepository }
        Resolver.test.register { EpisodesRepositoryMock() as EpisodesRepository }
    }
}
