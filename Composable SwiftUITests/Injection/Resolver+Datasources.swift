import Resolver

@testable import Composable_SwiftUI

extension Resolver {

    static func registerMockDatasources() {
        Resolver.test.register { CharacterRemoteDatasourceMock() as CharacterRemoteDatasource }
        Resolver.test.register { EpisodesRemoteDatasourceMock() as EpisodesRemoteDatasource }
        Resolver.test.register { LocationRemoteDatasourceMock() as LocationRemoteDatasource }
    }
}
