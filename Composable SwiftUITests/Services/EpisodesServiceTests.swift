import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "EpisodesService",
    .tags(.service)
)
struct EpisodesServiceTests {

    @Test(
        arguments: [
            [2],
            [1, 2],
            [1, 2, 8, 69],
            [3, 6, 7, 12, 400, 2000]
        ]
    )
    func getEpisodesListUsedApiRequest(ids: [Int]) async throws {
        let apiClient = APIClientMock()
        let service = EpisodesService(
            apiClient: apiClient
        )

        do {
            // TODO: JLI - @discardableResult
            try await service.getEpisodesList(ids: ids)

        } catch {
            let idsString = ids.map { "\($0)" }.joined(separator: ",")

            let usedApiRequest = try #require(apiClient.usedApiRequest)
            #expect(usedApiRequest.baseURL == "https://rickandmortyapi.com")
            #expect(usedApiRequest.apiVersion == .v1)
            #expect(usedApiRequest.path == "/episode/\(idsString)")
            #expect(usedApiRequest.urlParams.isEmpty)
            #expect(usedApiRequest.method == .get)
            #expect(usedApiRequest.headers == [:])
            #expect(usedApiRequest.body == nil)

            let urlRequest = try #require(usedApiRequest.urlRequest)
            let url = try #require(urlRequest.url)
            #expect(url.absoluteString == "https://rickandmortyapi.com/api/episode/\(idsString)")
        }
    }
}
