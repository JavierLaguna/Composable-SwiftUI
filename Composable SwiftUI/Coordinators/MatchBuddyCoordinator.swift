import SwiftUI
import Stinsen

final class MatchBuddyCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MatchBuddyCoordinator.start)

    @Root var start = makeStart
    @Route(.modal) var info = makeInfo

    let character: Character

    init(character: Character) {
        self.character = character
    }

    deinit {
        print("Deinit HomeCoordinator")
    }
}

extension MatchBuddyCoordinator {

    @ViewBuilder func makeStart() -> some View {
        MatchBuddyView(character: character)
    }

    @ViewBuilder func makeInfo() -> some View {
        MatchBuddyInfoView()
    }
}
