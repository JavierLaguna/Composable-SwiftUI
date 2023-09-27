
import XCTest
import SwiftUI
import SnapshotTesting
import Resolver

@testable import Composable_SwiftUI

final class CharactersListViewTests: XCTestCase {
     
    private let error = InteractorError.generic(message: "")
    private let characters = [
        Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: []),
        Character(id: 2, name: "Morty", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [])
    ]
    
    override func setUp() {
        super.setUp()
        
        Resolver.resetUnitTestRegistrations()
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()

//        isRecording = true
    }
    
    override func tearDown() {
        super.tearDown()
        
        Resolver.tearDown()
    }

    func test_charactersListView_loadingState_13MiniLight_snapshot() {
        let state = CharactersListReducer.State(
            characters: .init(state: .loading)
        )
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                perceptualPrecision: 0.98, 
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_charactersListView_loadingState_13MiniDark_snapshot() {
        let state = CharactersListReducer.State(
            characters: .init(state: .loading)
        )
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
    
    func test_charactersListView_loadingStateWithData_13MiniLight_snapshot() {
        var state = CharactersListReducer.State(
            characters: .init(state: .populated(data: characters))
        )
        state.characters.state = .loading
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_charactersListView_loadingStateWithData_13MiniDark_snapshot() {
        var state = CharactersListReducer.State(
            characters: .init(state: .populated(data: characters))
        )
        state.characters.state = .loading
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
    
    func test_charactersListView_populatedState_13MiniLight_snapshot() {
        let state = CharactersListReducer.State(
            characters: .init(state: .populated(data: characters))
        )
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_charactersListView_populatedState_13MiniDark_snapshot() {
        let state = CharactersListReducer.State(
            characters: .init(state: .populated(data: characters))
        )
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }

    func test_charactersListView_errorState_13MiniLight_snapshot() {
        let state = CharactersListReducer.State(
            characters: .init(state: .error(error))
        )
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_charactersListView_errorState_13MiniDark_snapshot() {
        let state = CharactersListReducer.State(
            characters: .init(state: .error(error))
        )
        configureStore(with: state)
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
}

// MARK: Private methods
private extension CharactersListViewTests {
    
    func configureStore(with state: CharactersListReducer.State) {
        let store = CharactersListStore(
            initialState: state,
            reducer: { }
        )
        Resolver.test.register(name: "scoped") { store as CharactersListStore }
    }
}
