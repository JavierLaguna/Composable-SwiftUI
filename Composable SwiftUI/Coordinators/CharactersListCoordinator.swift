import SwiftUI
import Stinsen

final class CharactersListCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \CharactersListCoordinator.start)

    @Root var start = makeStart
    @Route(.push) var character = makeCharacter
    
    init() {
        
    }
    
    deinit {
        print("Deinit HomeCoordinator")
    }
}

extension CharactersListCoordinator {
    
    @ViewBuilder func makeStart() -> some View {
        CharactersListView()
    }
    
    func makeCharacter(character: Character) -> CharacterHomeCoordinator {
        return CharacterHomeCoordinator(character: character)
    }
}
