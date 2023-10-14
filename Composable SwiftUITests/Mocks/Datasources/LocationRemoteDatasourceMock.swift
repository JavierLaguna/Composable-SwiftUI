@testable import Composable_SwiftUI

struct LocationRemoteDatasourceMock: LocationRemoteDatasource {

    var success: Bool = true
    var expectedResponse: LocationResponse = LocationResponse(id: 1, name: "Earth", type: "Planet", dimension: "dim", residents: ["url/1", "url/2"])
    var expectedError: RepositoryError = .invalidUrl

    func getLocation(locationId: Int) async throws -> LocationResponse {
        if success {
            return expectedResponse
        } else {
            throw expectedError
        }
    }
}
