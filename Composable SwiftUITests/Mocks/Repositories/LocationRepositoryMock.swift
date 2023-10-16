@testable import Composable_SwiftUI

struct LocationRepositoryMock: LocationRepository {

    var success: Bool = true
    var expectedResponse: [Int] = [1, 2, 3]
    var expectedError: RepositoryError = .invalidUrl

    func getCharacterIdsFromLocation(locationId: Int) async throws -> [Int] {
        if success {
            return expectedResponse
        } else {
            throw expectedError
        }
    }

    func getLocation(locationId: Int) async throws -> Location {
        if success {
            return Location(id: 1, name: "Eartch", type: .planet, dimension: "dim", residents: [1, 4])
        } else {
            throw expectedError
        }
    }
}
