import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "LocationService",
    .tags(.service)
)
struct LocationServiceTests {

    @Test(
        arguments: [
            1,
            2,
            8,
            69
        ]
    )
    func getLocationUsedApiRequest(id: Int) async throws {
        let apiClient = APIClientMock()
        let service = LocationService(
            apiClient: apiClient
        )

        do {
            try await service.getLocation(locationId: id)

        } catch {
            let usedApiRequest = try #require(apiClient.usedApiRequest)
            #expect(usedApiRequest.baseURL == "https://rickandmortyapi.com")
            #expect(usedApiRequest.apiVersion == .v1)
            #expect(usedApiRequest.path == "/location/\(id)")
            #expect(usedApiRequest.urlParams.isEmpty)
            #expect(usedApiRequest.method == .get)
            #expect(usedApiRequest.headers == [:])
            #expect(usedApiRequest.body == nil)

            let urlRequest = try #require(usedApiRequest.urlRequest)
            let url = try #require(urlRequest.url)
            #expect(url.absoluteString == "https://rickandmortyapi.com/api/location/\(id)")
        }
    }
}
