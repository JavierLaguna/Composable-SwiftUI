import Foundation

final class CharacterService: HttpClient, CharacterRemoteDatasource, @unchecked Sendable {

    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/character"

    func getCharacters(page: Int? = nil) async throws -> GetCharactersResponse {
        var urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)"),
            resolvingAgainstBaseURL: false
        )

        if let page = page {
            let queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            urlComponents?.queryItems = queryItems
        }

        guard let url = urlComponents?.url else {
            throw RepositoryError.invalidUrl
        }

        do {
            return try await get(from: url)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }

    func getCharacter(by id: Int) async throws -> CharacterResponse {
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(id)"),
            resolvingAgainstBaseURL: false
        )

        guard let url = urlComponents?.url else {
            throw RepositoryError.invalidUrl
        }

        do {
            return try await get(from: url)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }

    func getCharacters(by characterIds: [Int]) async throws -> [CharacterResponse] {
        guard !characterIds.isEmpty else {
            throw RepositoryError.invalidParameters
        }

        if characterIds.count == 1, let id = characterIds.first {
            let response = try await getCharacter(by: id)
            return [response]
        }

        let idsParam = characterIds.map { "\($0)" }.joined(separator: ",")
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(idsParam)"),
            resolvingAgainstBaseURL: false
        )

        guard let url = urlComponents?.url else {
            throw RepositoryError.invalidUrl
        }

        do {
            return try await get(from: url)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }
}
