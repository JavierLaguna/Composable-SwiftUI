import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "GetLocationsInteractorDefault",
    .tags(.interactor)
)
struct GetLocationsInteractorDefaultTests {

    @Test
    func executeSuccess() async throws {
        let mockRepository = MockLocationRepository()
        let mockResponse = [
            Location(
                id: 1,
                name: "Earth (C-137)",
                type: .planet,
                dimension: "Dimension C-137",
                residents: [1, 2]
            ),
            Location(
                id: 2,
                name: "Abadango",
                type: .cluster,
                dimension: "unknown",
                residents: [6, 7, 8]
            )
        ]
        let interactor = GetLocationsInteractorDefault(locationRepository: mockRepository)

        given(mockRepository)
            .getLocations()
            .willReturn(mockResponse)

        let result = try await interactor.execute()

        #expect(result == mockResponse)

        verify(mockRepository)
            .getLocations()
            .called(.once)

        verify(mockRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .called(.never)

        verify(mockRepository)
            .getLocation(locationId: .any)
            .called(.never)
    }

    @Test
    func executeFailMapsRepositoryError() async throws {
        let mockRepository = MockLocationRepository()
        let repositoryError = RepositoryError.invalidUrl
        let expectedError = InteractorError.repositoryFail(error: repositoryError)
        let interactor = GetLocationsInteractorDefault(locationRepository: mockRepository)

        given(mockRepository)
            .getLocations()
            .willThrow(repositoryError)

        try await #require(throws: expectedError) {
            try await interactor.execute()
        }

        verify(mockRepository)
            .getLocations()
            .called(.once)

        verify(mockRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .called(.never)

        verify(mockRepository)
            .getLocation(locationId: .any)
            .called(.never)
    }

    @Test
    func executeFailPropagatesNonRepositoryError() async throws {
        let mockRepository = MockLocationRepository()
        let expectedError = InteractorError.generic(message: "mock generic error")
        let interactor = GetLocationsInteractorDefault(locationRepository: mockRepository)

        given(mockRepository)
            .getLocations()
            .willThrow(expectedError)

        try await #require(throws: expectedError) {
            try await interactor.execute()
        }

        verify(mockRepository)
            .getLocations()
            .called(.once)

        verify(mockRepository)
            .getCharacterIdsFromLocation(locationId: .any)
            .called(.never)

        verify(mockRepository)
            .getLocation(locationId: .any)
            .called(.never)
    }
}
