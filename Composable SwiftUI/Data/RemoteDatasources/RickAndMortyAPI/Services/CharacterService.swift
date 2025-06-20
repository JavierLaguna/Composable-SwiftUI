import Foundation

struct CharacterService: CharacterRemoteDatasource {

    let apiClient: any APIClient

    @discardableResult
    func getCharacters(page: Int? = nil) async throws -> GetCharactersResponse {
        var urlParams: [String: any CustomStringConvertible] = [:]
        if let page {
            urlParams["page"] = "\(page)"
        }

        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: APIConstants.characterPath,
            urlParams: urlParams,
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }

    @discardableResult
    func getCharacter(by id: Int) async throws -> CharacterResponse {
        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: "\(APIConstants.characterPath)/\(id)",
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }

    @discardableResult
    func getCharacters(by characterIds: [Int]) async throws -> [CharacterResponse] {
        guard !characterIds.isEmpty else {
            throw RepositoryError.invalidParameters
        }

        if characterIds.count == 1, let id = characterIds.first {
            let response = try await getCharacter(by: id)
            return [response]
        }

        let idsParam = characterIds.map { "\($0)" }.joined(separator: ",")
        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: "\(APIConstants.characterPath)/\(idsParam)",
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }
}
