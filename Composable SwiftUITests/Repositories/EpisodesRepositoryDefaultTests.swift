import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

final class EpisodesRepositoryDefaultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }
    
    func testGetEpisodesFromListSuccess() throws {
        let datasource = EpisodesRemoteDatasourceMock()
        Resolver.test.register { datasource as EpisodesRemoteDatasource }
        
        let repository = EpisodesRepositoryDefault()
        let result = try awaitPublisher(repository.getEpisodesFromList(ids: [1, 2]))
        
        XCTAssertEqual(result.count, datasource.expectedResponse.count)
        XCTAssertEqual(result, datasource.expectedResponse.map { $0.toDomain() })
    }
    
    func testGetEpisodesFromListFail() throws {
        let datasource = EpisodesRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as EpisodesRemoteDatasource }
        
        let repository = EpisodesRepositoryDefault()

        XCTAssertThrowsError(try awaitPublisher(repository.getEpisodesFromList(ids: [1, 2]))) { error in
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }
}
