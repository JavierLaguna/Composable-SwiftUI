import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "LocationRepositoryDefault",
    .tags(.repository)
)
struct LocationRepositoryDefaultTests {

    @Test
    func getCharacterIdsFromLocationSuccess() async throws {
        let mockDatasource = MockLocationRemoteDatasource()
        let repository = LocationRepositoryDefault(service: mockDatasource)
        let mockResponse = LocationResponse(
            id: 1,
            name: "Earth",
            type: "Planet",
            dimension: "dim",
            residents: ["url/1", "url/2"]
        )

        given(mockDatasource)
            .getLocation(locationId: .any)
            .willReturn(mockResponse)

        let result = try await repository.getCharacterIdsFromLocation(locationId: 1)

        #expect(result == [1, 2])

        verify(mockDatasource)
            .getLocation(locationId: .value(1))
            .called(.once)
    }

    @Test
    func getCharacterIdsFromLocationFail() async throws {
        let mockDatasource = MockLocationRemoteDatasource()
        let mockError: RepositoryError = .invalidUrl
        let repository = LocationRepositoryDefault(service: mockDatasource)

        given(mockDatasource)
            .getLocation(locationId: .any)
            .willThrow(mockError)

        try await #require(throws: RepositoryError.invalidUrl) {
            try await repository.getCharacterIdsFromLocation(locationId: 1)
        }

        verify(mockDatasource)
            .getLocation(locationId: .value(1))
            .called(.once)
    }
}
