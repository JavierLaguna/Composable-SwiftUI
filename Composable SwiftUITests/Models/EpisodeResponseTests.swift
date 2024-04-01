import XCTest
import InlineSnapshotTesting

@testable import Composable_SwiftUI

final class EpisodeResponseTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        //        isRecording = true
    }
    
    func test_EpisodeResponse_jsonEncode_returnsValidJSON() {
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
    
    func test_EpisodeResponse_toDomain_returnsExpectedDomainObject() {
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
        
        XCTAssertEqual(response.toDomain(), domainDto)
    }
}
