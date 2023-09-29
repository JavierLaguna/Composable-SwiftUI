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
    
    func testExecuteSuccess() async {
        let repository = CharactersRepositoryMock()
        Resolver.test.register { repository as CharactersRepository }
        
        let interactor = GetCharactersInteractorDefault()
        
        do {
            let result = try await interactor.execute()
            
            XCTAssertEqual(result.count, repository.expectedResponse.count)
            XCTAssertEqual(result, repository.expectedResponse)
            
        } catch {
            XCTFail("Test Fail")
        }
    }
    
    func testExecuteFail() async {
        let repository = CharactersRepositoryMock(success: false)
        Resolver.test.register { repository as CharactersRepository }
        
        let interactor = GetCharactersInteractorDefault()
        
        do {
            _ = try await interactor.execute()
            
            XCTFail("Test Fail")
            
        } catch {
            
            XCTAssertEqual(error as? InteractorError,
                           .repositoryFail(error: .invalidUrl)
            )
        }
    }
}
