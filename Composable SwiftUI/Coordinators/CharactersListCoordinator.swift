import Observation
import SwiftUI
import Resolver
import ComposableArchitecture

@Observable
final class CharactersCoordinator {

    var path: [Routes] = []
    var pathBinding: Binding<[Routes]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    func navigateToCharacterDetail(character: Character) {
        path.append(.beerBuddy(character))
    }

    func navigateToBeerBuddy(character: Character) {
        path.append(.beerBuddy(character))
    }
}

// MARK: Routes
extension CharactersCoordinator {

    enum Routes: Hashable, View {
        case root
        case characterDetail(Character)
        case beerBuddy(Character)

        // MARK: View
        var body: some View {
            @Injected(name: "scoped") var store: StoreOf<CharactersListReducer>

            switch self {
            case .root:
                CharactersListView(store: store)

            case .characterDetail(let character):
                CharacterDetailView(character: character)

            case .beerBuddy(let character):
                MatchBuddyView(character: character)
            }
        }
    }
}
