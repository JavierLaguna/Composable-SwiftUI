import Foundation

final class EpisodesService: HttpClient, EpisodesRemoteDatasource {

    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/episode"

    func getEpisodesList(ids: [Int]) async throws -> [EpisodeResponse] {
        let idsParam = ids.map { "\($0)" }.joined(separator: ",")
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
