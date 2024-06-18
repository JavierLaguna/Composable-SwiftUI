import Observation
import SwiftUI
import Resolver
import ComposableArchitecture

@Observable
final class CharactersCoordinator {

    private(set) var path: [Routes] = []
    var pathBinding: Binding<[Routes]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    private(set) var sheet: Sheet?
    var sheetIsPresented: Binding<Bool> {
        Binding(
            get: { self.sheet != nil },
            set: { self.sheet = $0 ? self.sheet : nil }
        )
    }

    func navigateToCharacterDetail(character: Character) {
        path.append(.characterDetail(character))
    }

    func navigateToBeerBuddy(character: Character) {
        path.append(.beerBuddy(character))
    }

    func navigateToNeighbors(character: Character) {
        path.append(.neighbors(character))
    }

    func showBeerBuddyInfo() {
        sheet = .beerBuddyInfo
    }

    func showBeerBuddyCharacterDetail(character: Character) {
        sheet = .beerBuddyCharacterDetail(character)
    }
}

// MARK: Routes
extension CharactersCoordinator {

    enum Routes: Hashable, View {
        case root
        case characterDetail(Character)
        case beerBuddy(Character)
        case neighbors(Character)

        // MARK: View
        var body: some View {
            switch self {
            case .root:
                @Injected(name: "scoped") var store: StoreOf<CharactersListReducer>
                CharactersListView(store: store)

            case .characterDetail(let character):
                CharacterDetailView(character: character)

            case .beerBuddy(let character):
                MatchBuddyView(character: character)

            case .neighbors(let character):
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
    }
}

// MARK: Sheets
extension CharactersCoordinator {

    enum Sheet: Hashable, View {
        case beerBuddyInfo
        case beerBuddyCharacterDetail(Character)

        // MARK: View
        var body: some View {
            switch self {
            case .beerBuddyInfo:
                MatchBuddyInfoView()

            case .beerBuddyCharacterDetail(let character):
                CharacterDetailView(character: character)
            }
        }
    }
}
