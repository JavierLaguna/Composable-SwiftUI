import Testing
import ComposableArchitecture

@testable import Composable_SwiftUI

@Suite(
    "CharacterService",
    .tags(.service)
)
struct CharacterServiceTests {

    @Test(
        arguments: [
            nil,
            2,
            8,
            16
        ]
    )
    func getCharactersUsedApiRequest(pageNum: Int?) async throws {
        let apiClient = APIClientMock()
        let service = CharacterService(
            apiClient: apiClient
        )

        do {
            try await service.getCharacters(page: pageNum)

        } catch {
            let usedApiRequest = try #require(apiClient.usedApiRequest)
            #expect(usedApiRequest.baseURL == "https://rickandmortyapi.com")
            #expect(usedApiRequest.apiVersion == .v1)
            #expect(usedApiRequest.path == "/character")
            #expect(usedApiRequest.method == .get)
            #expect(usedApiRequest.headers == [:])
            #expect(usedApiRequest.body == nil)

            let urlRequest = try #require(usedApiRequest.urlRequest)
            let url = try #require(urlRequest.url)

            if let pageNum {
                let page = String(pageNum)
                #expect(usedApiRequest.urlParams.count == 1)
                #expect((usedApiRequest.urlParams["page"] as? String) == page)
                #expect(url.absoluteString == "https://rickandmortyapi.com/api/character?page=\(page)")

            } else {
                #expect(usedApiRequest.urlParams.isEmpty)
                #expect(url.absoluteString == "https://rickandmortyapi.com/api/character")
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
    func getCharacterByIdUsedApiRequest(id: Int) async throws {
        let apiClient = APIClientMock()
        let service = CharacterService(
            apiClient: apiClient
        )

        do {
            try await service.getCharacter(by: id)

        } catch {
            let usedApiRequest = try #require(apiClient.usedApiRequest)
            #expect(usedApiRequest.baseURL == "https://rickandmortyapi.com")
            #expect(usedApiRequest.apiVersion == .v1)
            #expect(usedApiRequest.path == "/character/\(id)")
            #expect(usedApiRequest.urlParams.isEmpty)
            #expect(usedApiRequest.method == .get)
            #expect(usedApiRequest.headers == [:])
            #expect(usedApiRequest.body == nil)

            let urlRequest = try #require(usedApiRequest.urlRequest)
            let url = try #require(urlRequest.url)
            #expect(url.absoluteString == "https://rickandmortyapi.com/api/character/\(id)")
        }
    }

    @Test(
        arguments: [
            [2],
            [1, 2],
            [1, 2, 8, 69],
            [3, 6, 7, 12, 400, 2000]
        ]
    )
    func getCharactersByIdsUsedApiRequest(ids: [Int]) async throws {
        let apiClient = APIClientMock()
        let service = CharacterService(
            apiClient: apiClient
        )

        do {
            try await service.getCharacters(by: ids)

        } catch {
            let idsString = ids.map { "\($0)" }.joined(separator: ",")

            let usedApiRequest = try #require(apiClient.usedApiRequest)
            #expect(usedApiRequest.baseURL == "https://rickandmortyapi.com")
            #expect(usedApiRequest.apiVersion == .v1)
            #expect(usedApiRequest.path == "/character/\(idsString)")
            #expect(usedApiRequest.urlParams.isEmpty)
            #expect(usedApiRequest.method == .get)
            #expect(usedApiRequest.headers == [:])
            #expect(usedApiRequest.body == nil)

            let urlRequest = try #require(usedApiRequest.urlRequest)
            let url = try #require(urlRequest.url)
            #expect(url.absoluteString == "https://rickandmortyapi.com/api/character/\(idsString)")
        }
    }
}
