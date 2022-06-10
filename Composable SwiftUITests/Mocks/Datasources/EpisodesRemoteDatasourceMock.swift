import Combine

@testable import Composable_SwiftUI

struct EpisodesRemoteDatasourceMock: EpisodesRemoteDatasource {
   
    var success: Bool = true
    var expectedResponse: [EpisodeResponse] = [
        EpisodeResponse(id: 1, name: "Episode 1", episode: "episode 1", date: "11-11-2011"),
        EpisodeResponse(id: 2, name: "Episode 2", episode: "episode 2", date: "12-12-2012")
    ]
    var expectedError: RepositoryError = .invalidUrl
    
    func getEpisodesList(ids: [Int]) -> AnyPublisher<[EpisodeResponse], RepositoryError> {
        guard success else {
            return Fail(error: expectedError)
                .eraseToAnyPublisher()
        }
        
        return Just(expectedResponse)
            .setFailureType(to: RepositoryError.self)
            .eraseToAnyPublisher()
    }
}
