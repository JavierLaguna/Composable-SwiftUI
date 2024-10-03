import Foundation

final class LocationService: HttpClient, LocationRemoteDatasource, @unchecked Sendable {

    private let baseURL = RickAndMortyAPI.apiBaseUrl
    private let path = "/location"

    func getLocation(locationId: Int) async throws -> LocationResponse {
        let urlComponents = URLComponents(
            url: baseURL.appendingPathComponent("\(path)/\(locationId)"),
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
