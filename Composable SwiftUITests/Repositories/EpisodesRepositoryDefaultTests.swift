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

    func testGetEpisodesFromListSuccess() async {
        let datasource = EpisodesRemoteDatasourceMock()
        Resolver.test.register { datasource as EpisodesRemoteDatasource }

        let repository = EpisodesRepositoryDefault()

        do {
            let result = try await repository.getEpisodesFromList(ids: [1, 2])

            XCTAssertEqual(result.count, datasource.expectedResponse.count)
            XCTAssertEqual(result, datasource.expectedResponse.map { $0.toDomain() })

        } catch {
            XCTFail("Test Fail")
        }
    }

    func testGetEpisodesFromListFail() async {
        let datasource = EpisodesRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as EpisodesRemoteDatasource }

        let repository = EpisodesRepositoryDefault()

        do {
            _ = try await repository.getEpisodesFromList(ids: [1, 2])

            XCTFail("Test Fail")

        } catch {
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }
}
