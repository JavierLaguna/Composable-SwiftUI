import Observation
import SwiftUI
import ComposableArchitecture

@Observable
final class MainCoordinator {

    private(set) var tabSelection: Int = Tab.characters.rawValue
    var tabSelectionBinding: Binding<Int> {
        Binding(
            get: { self.tabSelection },
            set: { self.tabSelection = $0 }
        )
    }

    func navigateToCharacters() {
        tabSelection = Tab.characters.rawValue
    }

    func navigateToEpisodes() {
        tabSelection = Tab.episodes.rawValue
    }

    func navigateToLocations() {
        tabSelection = Tab.locations.rawValue
    }
}

// MARK: Tabs
extension MainCoordinator {

    enum Tab: Int {
        case characters = 0
        case episodes = 1
        case locations = 2
    }
}

// MARK: View
extension MainCoordinator {

    struct RootView: View {

        let mainStore = StoreOf<MainReducer>(
            initialState: .init(),
            reducer: {
                MainReducer()
            }
        )

        var body: some View {
            MainView(mainStore: mainStore)
        }
    }
}
