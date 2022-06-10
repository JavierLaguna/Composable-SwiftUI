import SwiftUI
import Stinsen

final class MainCoordinator: NavigationCoordinatable {
    var stack: NavigationStack<MainCoordinator>

    @Root var charactersList = makeCharactersList

    init() {
        stack = NavigationStack(initial: \MainCoordinator.charactersList)
    }
    
    deinit {
        print("Deinit MainCoordinator")
    }
}

extension MainCoordinator {
    
    func makeCharactersList() -> NavigationViewCoordinator<CharactersListCoordinator> {
        return NavigationViewCoordinator(CharactersListCoordinator())
    }
}
