import Combine

@testable import Composable_SwiftUI

struct EpisodesRepositoryMock: EpisodesRepository {
   
    var success: Bool = true
    var expectedResponse: [Episode] = [
        Episode(id: 1, name: "episode1", date: "11-11-2011"),
        Episode(id: 2, name: "episode2", date: "22-12-2022")
    ]
    var expectedError: RepositoryError = .invalidUrl
    
    func getEpisodesFromList(ids: [Int]) -> AnyPublisher<[Episode], RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
}
