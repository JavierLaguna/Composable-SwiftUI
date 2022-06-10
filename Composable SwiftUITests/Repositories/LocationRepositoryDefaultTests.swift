import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

final class LocationRepositoryDefaultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }
    
    func testGetCharacterIdsFromLocationSuccess() throws {
        let datasource = LocationRemoteDatasourceMock()
        Resolver.test.register { datasource as LocationRemoteDatasource }
        
        let repository = LocationRepositoryDefault()
        let result = try awaitPublisher(repository.getCharacterIdsFromLocation(locationId: 1))
        
        XCTAssertEqual(result, [1, 2])
    }
    
    func testGetCharacterIdsFromLocationFail() throws {
        let datasource = LocationRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as LocationRemoteDatasource }
        
        let repository = LocationRepositoryDefault()

        XCTAssertThrowsError(try awaitPublisher(repository.getCharacterIdsFromLocation(locationId: 1))) { error in
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }
}
