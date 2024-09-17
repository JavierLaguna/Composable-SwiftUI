import Testing
import InlineSnapshotTesting

@testable import Composable_SwiftUI

@Suite("EpisodeResponse Tests", .tags(.mapper))
struct EpisodeResponseTests {

    @Test
    func episodeResponse_jsonEncode_returnsValidJSON() {
        let episodeResponse = EpisodeResponse(
            id: 1,
            name: "name",
            episode: "episode",
            date: "22-12-2022"
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
            episode: "episode",
            date: "22-12-2022"
        )

        let domainDto = Episode(
            id: 1,
            name: "name",
            date: "22-12-2022"
        )

        #expect(response.toDomain() == domainDto)
    }
}
