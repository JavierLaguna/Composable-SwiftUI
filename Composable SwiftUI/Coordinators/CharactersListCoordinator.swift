import SwiftUI
import Observation
import Resolver
import ComposableArchitecture

@Observable
final class CharactersListCoordinator {

    var path: [Routes] = []
    var pathBinding: Binding<[Routes]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    func character(character: Character) {
        path.append(.character(character))
    }
}

// MARK: Routes
extension CharactersListCoordinator {

    enum Routes: Hashable, View {
        case root
        case character(Character)

        // MARK: View
        var body: some View {
            @Injected(name: "scoped") var store: StoreOf<CharactersListReducer>

            switch self {
            case .root:
                CharactersListView(store: store)

            case .character(let character):
                CharacterDetailView(character: character)
            }
        }
    }
}
