import XCTest
import ComposableArchitecture
import Resolver

@testable import Composable_SwiftUI

final class CharactersListReducerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }
    
    func testBindingSearchText() {
        let store = TestStore(
            initialState: CharactersListState(),
            reducer: charactersListReducer,
            environment: Resolver.resolve()
        )
        
        store.send(.set(\.$searchText, "test text")) {
            $0.searchText = "test text"
        }
    }
    
    func testGetCharactersSuccess() {
        let interactor = GetCharactersInteractorMock()
        Resolver.test.register { interactor as GetCharactersInteractor }
        
        let store = TestStore(
            initialState: CharactersListState(),
            reducer: charactersListReducer,
            environment: Resolver.resolve()
        )
        
        store.send(.getCharacters) {
            $0.characters.state = .loading
        }
        store.receive(.onGetCharacters(.success(interactor.expectedResponse))) {
            $0.characters.state = .populated(data: interactor.expectedResponse)
        }
    }
    
    func testGetCharactersSuccessAndMoreCharacters() {
        let interactor = GetCharactersInteractorMock()
        Resolver.test.register { interactor as GetCharactersInteractor }
        
        let location = CharacterLocation(id: 1, name: "Earth")
        let initialCharacters: [Character] = [
            Character(id: 2, name: "Rick Gomez", status: .alive, species: "Human", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar11.jpeg", episodes: []),
            Character(id: 3, name: "Morty", status: .dead, species: "Alien", type: "", gender: .male, origin: location, location: location, image: "https://rickandmortyapi.com/api/character/avatar3.jpeg", episodes: [])
        ]
        
        let store = TestStore(
            initialState: CharactersListState(
                characters: StateLoadable(state: .populated(data: initialCharacters))
            ),
            reducer: charactersListReducer,
            environment: Resolver.resolve()
        )
        
        store.send(.getCharacters) {
            $0.characters.state = .loading
        }
        store.receive(.onGetCharacters(.success(interactor.expectedResponse))) {
            var newData = initialCharacters
            newData.append(contentsOf: interactor.expectedResponse)
            $0.characters.state = .populated(data: newData)
        }
    }
    
    func testGetCharactersFail() {
        Resolver.test.register { GetCharactersInteractorMock(success: false) as GetCharactersInteractor }
        
        let store = TestStore(
            initialState: CharactersListState(),
            reducer: charactersListReducer,
            environment: Resolver.resolve()
        )
        
        store.send(.getCharacters) {
            $0.characters.state = .loading
        }
        store.receive(.onGetCharacters(.failure(.generic(message: "mock error")))) {
            $0.characters.state = .error(InteractorError.generic(message: "mock error"))
        }
    }
}
