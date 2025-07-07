@testable import Composable_SwiftUI
import Foundation

struct EpisodesRepositoryMock: EpisodesRepository {

    var success: Bool = true
    var expectedResponse: [Episode] = [
        Episode(id: 1, name: "episode1", airDate: Date.now, code: "code-1", characters: [1, 2], created: Date.now, image: nil),
        Episode(id: 2, name: "episode2", airDate: Date.now, code: "code-1", characters: [2, 3, 4], created: Date.now, image: nil)
    ]
    var expectedError: RepositoryError = .invalidUrl

    func getEpisodesFromList(ids: [Int]) async throws -> [Episode] {
        if success {
            return expectedResponse
        } else {
            throw expectedError
        }
    }

    func getEpisodes() async throws -> [Episode] {
        if success {
            return expectedResponse
        } else {
            throw expectedError
        }
    }
}
