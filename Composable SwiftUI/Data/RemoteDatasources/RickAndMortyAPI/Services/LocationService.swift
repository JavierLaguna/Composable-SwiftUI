import Foundation

struct LocationService: LocationRemoteDatasource {

    let apiClient: any APIClient

    @discardableResult
    func getLocation(locationId: Int) async throws -> LocationResponse {
        let apiRequest = APIRequest(
            baseURL: APIConstants.baseURL,
            apiVersion: .v1,
            path: "\(APIConstants.locationPath)/\(locationId)",
            method: .get
        )

        do {
            return try await apiClient.request(apiRequest)
        } catch {
            throw RepositoryError.serviceFail(error: error)
        }
    }
}
