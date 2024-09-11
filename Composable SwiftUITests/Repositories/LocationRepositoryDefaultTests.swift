import Testing
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@Suite(
    "LocationRepositoryDefault Tests",
    .serialized
)
final class LocationRepositoryDefaultTests: ResetTestDependencies {

    @Test
    func getCharacterIdsFromLocationSuccess() async throws {
        let datasource = LocationRemoteDatasourceMock()
        Resolver.test.register { datasource as LocationRemoteDatasource }

        let repository = LocationRepositoryDefault()

        let result = try #require(await repository.getCharacterIdsFromLocation(locationId: 1))

        #expect(result == [1, 2])
    }

    @Test
    func getCharacterIdsFromLocationFail() async throws {
        let datasource = LocationRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as LocationRemoteDatasource }

        let repository = LocationRepositoryDefault()

        try await #require(throws: RepositoryError.invalidUrl) {
            try await repository.getCharacterIdsFromLocation(locationId: 1)
        }
    }
}
