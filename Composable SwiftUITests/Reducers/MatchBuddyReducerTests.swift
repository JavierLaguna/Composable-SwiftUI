import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

@MainActor
final class MatchBuddyReducerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }

    func testGetBeerBuddySuccess() async {
        let interactor = GetBeerBuddyInteractorMock()
        Resolver.test.register { interactor as GetBeerBuddyInteractor }
        
        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])
        
        let store = TestStore(
            initialState: MatchBuddyReducer.State(),
            reducer: {
                MatchBuddyReducer()
            }
        )
        
        await store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }
        
        await store.receive(.onGetBeerBuddy(.success(interactor.expectedResponse))) {
            $0.beerBuddy.state = .populated(data: interactor.expectedResponse!)
        }
    }

    func testGetBeerBuddyNotFoundSuccess() async {
        let interactor = GetBeerBuddyInteractorMock(success: true, expectedResponse: nil)
        Resolver.test.register { interactor as GetBeerBuddyInteractor }

        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])

        let store = TestStore(
            initialState: MatchBuddyReducer.State(),
            reducer: {
                MatchBuddyReducer()
            }
        )

        await store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }
        
        await store.receive(.onGetBeerBuddy(.success(interactor.expectedResponse))) {
            $0.beerBuddy.state = .empty
        }
    }

    func testGetBeerBuddyFail() async {
        Resolver.test.register { GetBeerBuddyInteractorMock(success: false) as GetBeerBuddyInteractor }

        let location = CharacterLocation(id: 1, name: "Earth")
        let character = Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: [])

        let store = TestStore(
            initialState: MatchBuddyReducer.State(),
            reducer: {
                MatchBuddyReducer()
            }
        )

        await store.send(.getBeerBuddy(of: character)) {
            $0.beerBuddy.state = .loading
        }
        
        await store.receive(.onGetBeerBuddy(.failure(InteractorError.generic(message: "mock error")))) {
            $0.beerBuddy.state = .error(InteractorError.generic(message: "mock error"))
        }
    }
}
