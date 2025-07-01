import Foundation

struct EpisodesService: EpisodesRemoteDatasource {

    let apiClient: any APIClient

    @discardableResult
    func getEpisode(id: Int) async throws -> EpisodeResponse {
        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: "\(APIConstants.episodePath)/\(id)",
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }

    @discardableResult
    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse] {
        guard !ids.isEmpty else {
            throw RepositoryError.invalidParameters
        }

        if ids.count == 1, let id = ids.first {
            let response = try await getEpisode(id: id)
            return [response]
        }

        let idsParam = ids.map { "\($0)" }.joined(separator: ",")
        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: "\(APIConstants.episodePath)/\(idsParam)",
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }

    @discardableResult
    func getEpisodes(page: Int?) async throws -> GetEpisodesResponse {
        var urlParams: [String: any CustomStringConvertible] = [:]
        if let page {
            urlParams["page"] = "\(page)"
        }

        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: APIConstants.episodePath,
            urlParams: urlParams,
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }
}
