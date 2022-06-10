import Combine

@testable import Composable_SwiftUI

struct LocationRemoteDatasourceMock: LocationRemoteDatasource {
    
    var success: Bool = true
    var expectedResponse: LocationResponse = LocationResponse(name: "Earth", url: "url", residents: ["url/1", "url/2"])
    var expectedError: RepositoryError = .invalidUrl
    
    func getLocation(locationId: Int) -> AnyPublisher<LocationResponse, RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
}
