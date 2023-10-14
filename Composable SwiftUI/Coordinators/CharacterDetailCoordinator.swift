import SwiftUI
import Stinsen

final class CharacterDetailCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \CharacterDetailCoordinator.start)

    @Root var start = makeStart

    private let character: Character

    init(character: Character) {
        self.character = character
    }

    deinit {
        print("Deinit CharacterDetailCoordinator")
    }
}

extension CharacterDetailCoordinator {

    @ViewBuilder func makeStart() -> some View {
        CharacterDetailView(character: character)
    }
}
