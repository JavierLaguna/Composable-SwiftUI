
import XCTest
import SwiftUI
import SnapshotTesting
import Resolver

@testable import Composable_SwiftUI

final class CharactersListViewTests: XCTestCase {
     
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
    // TODO: LOADING WITH DATA
    func test_charactersListView_loadingState_13MiniLight_snapshot() {
        let store = CharactersListStore(
            initialState: CharactersListReducer.State(
                characters: .init(state: .loading)
            ),
            reducer: { }
        )
        Resolver.test.register(name: "scoped") { store as CharactersListStore }
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_charactersListView_loadingState_13MiniDark_snapshot() {
        let store = CharactersListStore(
            initialState: CharactersListReducer.State(
                characters: .init(state: .loading)
            ),
            reducer: { }
        )
        Resolver.test.register(name: "scoped") { store as CharactersListStore }
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
    
    func test_charactersListView_populatedState_13MiniLight_snapshot() {
        let characters = [
            Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: []),
            Character(id: 2, name: "Morty", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [])
        ]
        let store = CharactersListStore(
            initialState: CharactersListReducer.State(
                characters: .init(state: .populated(data: characters))
            ),
            reducer: { }
        )
        Resolver.test.register(name: "scoped") { store as CharactersListStore }
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_charactersListView_populatedState_13MiniDark_snapshot() {
        let characters = [
            Character(id: 1, name: "Rick Sanchez", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg", episodes: []),
            Character(id: 2, name: "Morty", status: .alive, species: "Human", type: "", gender: .male, origin: CharacterLocation(id: 1, name: "Earth"), location: CharacterLocation(id: 1, name: "Earth"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episodes: [])
        ]
        let store = CharactersListStore(
            initialState: CharactersListReducer.State(
                characters: .init(state: .populated(data: characters))
            ),
            reducer: { }
        )
        Resolver.test.register(name: "scoped") { store as CharactersListStore }
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }

    func test_charactersListView_errorState_13MiniLight_snapshot() {
        let error = InteractorError.generic(message: "")
        let store = CharactersListStore(
            initialState: CharactersListReducer.State(
                characters: .init(state: .error(error))
            ),
            reducer: { }
        )
        Resolver.test.register(name: "scoped") { store as CharactersListStore }
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .light)
            )
        )
    }
    
    func test_charactersListView_errorState_13MiniDark_snapshot() {
        let error = InteractorError.generic(message: "")
        let store = CharactersListStore(
            initialState: CharactersListReducer.State(
                characters: .init(state: .error(error))
            ),
            reducer: { }
        )
        Resolver.test.register(name: "scoped") { store as CharactersListStore }
        
        assertSnapshot(
            matching: CharactersListView(),
            as: .image(
                layout: .device(config: .iPhone13Mini),
                traits: .init(userInterfaceStyle: .dark)
            )
        )
    }
}
