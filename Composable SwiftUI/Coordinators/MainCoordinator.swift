import Observation
import SwiftUI

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

extension MainCoordinator {

    enum Tab: Int {
        case characters = 0
        case episodes = 1
        case locations = 2
    }
}
