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
}
