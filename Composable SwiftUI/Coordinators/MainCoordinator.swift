import Observation
import SwiftUI

@Observable
final class MainCoordinator {

    var tabSelection: Int = Tab.characters.rawValue
    var tabSelectionBinding: Binding<Int> {
        Binding(
            get: { self.tabSelection },
            set: { self.tabSelection = $0 }
        )
    }

    func navigateToCharacters() {
        tabSelection = Tab.characters.rawValue
    }
}

extension MainCoordinator {

    enum Tab: Int {
        case characters = 0
    }
}
