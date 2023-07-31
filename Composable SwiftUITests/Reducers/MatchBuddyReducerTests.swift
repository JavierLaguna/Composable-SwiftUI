import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

final class MatchBuddyReducerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }
    
    func testGetBeerBuddySuccess() {
        let interactor = GetBeerBuddyInteractorMock()
        Resolver.test.register { interactor as GetBeerBuddyInteractor }
        
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
        
        let store = TestStore(
            initialState: MatchBuddyState(),
            reducer: matchBuddyReducer,
            environment: Resolver.resolve()
        )
        
        store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }
        store.receive(.onGetBeerBuddy(.success(interactor.expectedResponse))) {
            $0.beerBuddy.state = .populated(data: interactor.expectedResponse!)
        }
    }
    
    func testGetBeerBuddyNotFoundSuccess() {
        let interactor = GetBeerBuddyInteractorMock(success: true, expectedResponse: nil)
        Resolver.test.register { interactor as GetBeerBuddyInteractor }
        
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
        
        let store = TestStore(
            initialState: MatchBuddyState(),
            reducer: matchBuddyReducer,
            environment: Resolver.resolve()
        )
        
        store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }
        store.receive(.onGetBeerBuddy(.success(interactor.expectedResponse))) {
            $0.beerBuddy.state = .empty
        }
    }
    
    func testGetBeerBuddyFail() {
        Resolver.test.register { GetBeerBuddyInteractorMock(success: false) as GetBeerBuddyInteractor }
        
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
        
        let store = TestStore(
            initialState: MatchBuddyState(),
            reducer: matchBuddyReducer,
            environment: Resolver.resolve()
        )
        
        store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }
        store.receive(.onGetBeerBuddy(.failure(.generic(message: "mock error")))) {
            $0.beerBuddy.state = .error(InteractorError.generic(message: "mock error"))
        }
    }
}
