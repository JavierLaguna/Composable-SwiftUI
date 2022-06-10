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
    
    func testGetCharactersSuccess() throws {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }
        
        let repository = CharactersRepositoryDefault()
        
        XCTAssertNil(repository.nextPage)
        XCTAssertNil(repository.totalPages)
        
        let result = try awaitPublisher(repository.getCharacters())
        
        XCTAssertEqual(repository.nextPage, 2)
        XCTAssertEqual(repository.totalPages, 12)
        XCTAssertEqual(result.count, datasource.expectedResponseByPage.results.count)
        XCTAssertEqual(result, datasource.expectedResponseByPage.results.map { $0.toDomain() })
    }
    
    func testGetCharactersFail() throws {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }
        
        let repository = CharactersRepositoryDefault()
        
        XCTAssertThrowsError(try awaitPublisher(repository.getCharacters())) { error in
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }
    
    func testGetCharactersByIdSuccess() throws {
        let datasource = CharacterRemoteDatasourceMock()
        Resolver.test.register { datasource as CharacterRemoteDatasource }
        
        let repository = CharactersRepositoryDefault()
        
        XCTAssertNil(repository.nextPage)
        XCTAssertNil(repository.totalPages)
        
        let result = try awaitPublisher(repository.getCharacters(characterIds: [1, 2]))
        
        XCTAssertEqual(result.count, datasource.expectedResponseByIds.count)
        XCTAssertEqual(result, datasource.expectedResponseByIds.map { $0.toDomain() })
    }
    
    func testGetCharactersByIdFail() throws {
        let datasource = CharacterRemoteDatasourceMock(success: false)
        Resolver.test.register { datasource as CharacterRemoteDatasource }
        
        let repository = CharactersRepositoryDefault()
        
        XCTAssertThrowsError(try awaitPublisher(repository.getCharacters(characterIds: [1, 2]))) { error in
            XCTAssertEqual(error as? RepositoryError, .invalidUrl)
        }
    }
}
