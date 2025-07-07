import Foundation
import Testing
import InlineSnapshotTesting

@testable import Composable_SwiftUI

@Suite(
    "EpisodeResponse",
    .tags(.mapper)
)
struct EpisodeResponseTests {

    @Test
    func episodeResponse_jsonEncode_returnsValidJSON() {
        let episodeResponse = EpisodeResponse(
            id: 1,
            name: "name",
            airDate: "22-12-2022",
            episode: "episode",
            characters: ["1"],
            created: "created"
        )

        assertInlineSnapshot(of: episodeResponse, as: .json) {
"""
{
  "air_date" : "22-12-2022",
  "episode" : "episode",
  "id" : 1,
  "name" : "name"
}
"""
        }
    }

    @Test
    func episodeResponse_toDomain_returnsExpectedDomainObject() {
        let response = EpisodeResponse(
            id: 1,
            name: "name",
            airDate: "22-12-2022",
            episode: "episode",
            characters: ["1"],
            created: "created"
        )

        let domainDto = Episode(
            id: 1,
            name: "name",
            airDate: Date.now,
            code: "episode",
            characters: [1],
            created: Date.now,
            image: nil
        )

        #expect(response.toDomain() == domainDto)
    }
}
