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
            nil,
            2,
            8,
            16
        ]
    )
    func getLocationsUsedApiRequest(pageNum: Int?) async throws {
        let apiClient = APIClientMock()
        let service = LocationService(
            apiClient: apiClient
        )

        do {
            try await service.getLocations(page: pageNum)

        } catch {
            let usedApiRequest = try #require(apiClient.usedApiRequest)
            #expect(usedApiRequest.baseURL == "https://rickandmortyapi.com")
            #expect(usedApiRequest.apiVersion == .v1)
            #expect(usedApiRequest.path == "/location")
            #expect(usedApiRequest.method == .get)
            #expect(usedApiRequest.headers == [:])
            #expect(usedApiRequest.body == nil)

            let urlRequest = try #require(usedApiRequest.urlRequest)
            let url = try #require(urlRequest.url)

            if let pageNum {
                let page = String(pageNum)
                #expect(usedApiRequest.urlParams.count == 1)
                #expect((usedApiRequest.urlParams["page"] as? String) == page)
                #expect(url.absoluteString == "https://rickandmortyapi.com/api/location?page=\(page)")

            } else {
                #expect(usedApiRequest.urlParams.isEmpty)
                #expect(url.absoluteString == "https://rickandmortyapi.com/api/location")
            }
        }
    }

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
