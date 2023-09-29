import SwiftUI
import Stinsen
import ComposableArchitecture

final class CharacterNeighborsCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \CharacterNeighborsCoordinator.start)

    @Root var start = makeStart
    
    private let character: Character

    init(character: Character) {
        self.character = character
    }
    
    deinit {
        print("Deinit CharacterNeighborsCoordinator")
    }
}

extension CharacterNeighborsCoordinator {
    
    @ViewBuilder func makeStart() -> some View {
        CharacterNeighborsView(
            store: Store(
                initialState: .init(),
                reducer: {
                    CharacterNeighborsReducer(locationId: character.location.id)
                }
            )
        )
    }
}
