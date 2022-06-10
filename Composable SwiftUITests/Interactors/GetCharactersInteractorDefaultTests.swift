import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

final class GetCharactersInteractorDefaultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }
    
    func testExecuteSuccess() throws {
        let repository = CharactersRepositoryMock()
        Resolver.test.register { repository as CharactersRepository }
        
        let interactor = GetCharactersInteractorDefault()
        let result = try awaitPublisher(interactor.execute())
        
        XCTAssertEqual(result.count, repository.expectedResponse.count)
        XCTAssertEqual(result, repository.expectedResponse)
    }
    
    func testExecuteFail() throws {
        let repository = CharactersRepositoryMock(success: false)
        Resolver.test.register { repository as CharactersRepository }
        
        let interactor = GetCharactersInteractorDefault()
        
        XCTAssertThrowsError(try awaitPublisher(interactor.execute())) { error in
            XCTAssertEqual(error as? InteractorError,
                           .repositoryFail(error: .invalidUrl)
            )
        }
    }
}
