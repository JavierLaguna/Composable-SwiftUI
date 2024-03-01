import SwiftUI
import Stinsen
import Resolver
import ComposableArchitecture

final class CharactersListCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \CharactersListCoordinator.start)

    @Root var start = makeStart
    @Route(.push) var character = makeCharacter

    @Injected(name: "scoped") private var store: StoreOf<CharactersListReducer>
}

// MARK: Private methods
private extension CharactersListCoordinator {

    @ViewBuilder
    func makeStart() -> some View {
        CharactersListView(store: store)
    }

    func makeCharacter(character: Character) -> CharacterHomeCoordinator {
        return CharacterHomeCoordinator(character: character)
    }
}
