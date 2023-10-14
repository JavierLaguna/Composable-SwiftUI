import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

final class CharactersRepositoryDefaultTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Resolver.resetUnitTestRegistrations()
    }

    override func tearDown() {
        super.tearDown()

        Resolver.tearDown()
    }

    func testGetCharactersSuccess() async {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        XCTAssertNil(repository.nextPage)
        XCTAssertNil(repository.totalPages)

        do {
            let result = try await repository.getCharacters()

            XCTAssertEqual(repository.nextPage, 2)
            XCTAssertEqual(repository.totalPages, 12)
            XCTAssertEqual(result.count, datasource.expectedResponseByPage.results.count)
            XCTAssertEqual(result, datasource.expectedResponseByPage.results.map { $0.toDomain() })

        } catch {
            XCTFail("Test Fail")
        }
    }

    func testGetCharactersFail() async {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        do {
            _ = try await repository.getCharacters()

            XCTFail("Test Fail")

        } catch {
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }

    func testGetCharactersByIdSuccess() async {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        XCTAssertNil(repository.nextPage)
        XCTAssertNil(repository.totalPages)

        do {
            let result = try await repository.getCharacters(characterIds: [1, 2])

            XCTAssertEqual(result.count, datasource.expectedResponseByIds.count)
            XCTAssertEqual(result, datasource.expectedResponseByIds.map { $0.toDomain() })

        } catch {
            XCTFail("Test Fail")
        }
    }

    func testGetCharactersByIdFail() async {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }

        let repository = CharactersRepositoryDefault()

        do {
            _ = try await repository.getCharacters(characterIds: [1, 2])

            XCTFail("Test Fail")

        } catch {
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }
}
