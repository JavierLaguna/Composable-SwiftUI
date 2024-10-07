import Foundation

struct EpisodesService: EpisodesRemoteDatasource {

    let apiClient: APIClient

    @discardableResult
    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse] {
        let idsParam = ids.map { "\($0)" }.joined(separator: ",")
        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: APIConstants.episodePath + "/" + idsParam,
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }
}
