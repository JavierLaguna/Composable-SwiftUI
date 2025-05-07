import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "LocationRepositoryDefault",
    .tags(.repository)
)
struct LocationRepositoryDefaultTests {

    @Test
    func getCharacterIdsFromLocationSuccess() async throws {
        let datasource = LocationRemoteDatasourceMock()
        let repository = LocationRepositoryDefault(service: datasource)

        let result = try await repository.getCharacterIdsFromLocation(locationId: 1)

        #expect(result == [1, 2])
    }

    @Test
    func getCharacterIdsFromLocationFail() async throws {
        let datasource = LocationRemoteDatasourceMock(success: false)
        let repository = LocationRepositoryDefault(service: datasource)

        try await #require(throws: RepositoryError.invalidUrl) {
            try await repository.getCharacterIdsFromLocation(locationId: 1)
        }
    }
}
