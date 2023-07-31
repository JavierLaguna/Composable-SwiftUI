import Combine

@testable import Composable_SwiftUI

struct LocationRepositoryMock: LocationRepository {
   
    var success: Bool = true
    var expectedResponse: [Int] = [1, 2, 3]
    var expectedError: RepositoryError = .invalidUrl
    
    func getCharacterIdsFromLocation(locationId: Int) -> AnyPublisher<[Int], RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
    
    func getLocation(locationId: Int) async throws -> Location { // TODO: JLI
        Location(id: 1, name: "Eartch", type: .planet, dimension: "dim", residents: [1, 4])
    }
}
