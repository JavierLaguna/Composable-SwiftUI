import Foundation
import Testing
@testable import Composable_SwiftUI

@Suite(
    "Character",
    .tags(.model)
)
struct CharacterTests {

    @Test
    func matchedEpisodes() {
        let rick = Character.rick.copy(episodes: [1, 2, 15, 22, 33, 200, 301])
        let morty = Character.morty.copy(episodes: [1, 2, 15, 44, 35, 200, 301, 304])

        let matchedEpisodes = rick.matchedEpisodes(with: morty)

        #expect(matchedEpisodes?.character == rick)
        #expect(matchedEpisodes?.count == 5)
        #expect(matchedEpisodes?.diff == 300)
        #expect(matchedEpisodes?.firstEpisode == 1)
        #expect(matchedEpisodes?.lastEpisode == 301)
    }

    @Test
    func matchedEpisodesReturnNil() {
        let rick = Character.rick.copy(episodes: [1, 2])
        let morty = Character.morty.copy(episodes: [200, 301])

        let matchedEpisodes = rick.matchedEpisodes(with: morty)

        #expect(matchedEpisodes == nil)
    }
}
