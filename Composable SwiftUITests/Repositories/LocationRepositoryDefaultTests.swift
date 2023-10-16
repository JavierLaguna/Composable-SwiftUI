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

    func testGetCharacterIdsFromLocationSuccess() async {
        let datasource = LocationRemoteDatasourceMock()
        Resolver.test.register { datasource as LocationRemoteDatasource }

        let repository = LocationRepositoryDefault()

        do {
            let result = try await repository.getCharacterIdsFromLocation(locationId: 1)

            XCTAssertEqual(result, [1, 2])

        } catch {
            XCTFail("Test Fail")
        }
    }

    func testGetCharacterIdsFromLocationFail() async {
        let datasource = LocationRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as LocationRemoteDatasource }

        let repository = LocationRepositoryDefault()

        do {
            _ = try await repository.getCharacterIdsFromLocation(locationId: 1)

            XCTFail("Test Fail")

        } catch {
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }
}
