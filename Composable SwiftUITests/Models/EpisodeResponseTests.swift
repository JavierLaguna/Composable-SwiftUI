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
            id: 28,
            name: "The Ricklantis Mixup",
            airDate: "September 10, 2017",
            episode: "S03E07",
            characters: [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/2"
            ],
            created: "2017-11-10T12:56:36.618Z"
        )

        assertInlineSnapshot(of: episodeResponse, as: .json) {
            #"""
            {
              "air_date" : "September 10, 2017",
              "characters" : [
                "https:\/\/rickandmortyapi.com\/api\/character\/1",
                "https:\/\/rickandmortyapi.com\/api\/character\/2"
              ],
              "created" : "2017-11-10T12:56:36.618Z",
              "episode" : "S03E07",
              "id" : 28,
              "name" : "The Ricklantis Mixup"
            }
            """#
        }
    }

    @Test
    func episodeResponse_toDomain_returnsExpectedDomainObject() {
        let response = EpisodeResponse(
            id: 1,
            name: "name",
            airDate: "December 2, 2013",
            episode: "episode",
            characters: ["1"],
            created: "2017-11-04T18:48:46.250Z"
        )

        let domainDto = Episode(
            id: 1,
            name: "name",
            airDate: "December 2, 2013".dateFromApiMonthDayYearDateString()!,
            code: "episode",
            characters: [1],
            created: "2017-11-04T18:48:46.250Z".dateFromApiDateString()!,
            image: nil
        )

        #expect(response.toDomain() == domainDto)
    }
}
