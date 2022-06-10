import SwiftUI
import Stinsen

final class CharacterHomeCoordinator: TabCoordinatable {

    var child = TabChild(
        startingItems: [
            \CharacterHomeCoordinator.characterDetail,
            \CharacterHomeCoordinator.matchBuddy
        ]
    )

    @Route(tabItem: makeCharacterDetailTab) var characterDetail = makeCharacterDetail
    @Route(tabItem: makeMatchBuddyTab) var matchBuddy = makeMatchBuddy

    private let character: Character
    
    init(character: Character) {
        self.character = character

        configureNavAppearance()
        configureTabAppearance()
    }

    deinit {
        print("Deinit AuthenticatedCoordinator")
    }
    
    private func configureNavAppearance() {
        NavigationBarAppearance.navigationBarColors(background: .clear, titleColor: .white, showLineSeparator: false)
    }
    
    private func configureTabAppearance() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor(Theme.Colors.background)
    }
}

extension CharacterHomeCoordinator {

    func makeCharacterDetail() -> CharacterDetailCoordinator {
        return CharacterDetailCoordinator(character: character)
    }

    @ViewBuilder func makeCharacterDetailTab(isActive: Bool) -> some View {
        Label(
            R.string.localizable.tabBarDetails(),
            systemImage: "figure.walk.diamond.fill"
        )
    }

    func makeMatchBuddy() -> MatchBuddyCoordinator {
        return MatchBuddyCoordinator(character: character)
    }

    @ViewBuilder func makeMatchBuddyTab(isActive: Bool) -> some View {
        Label(
            R.string.localizable.tabBarBeerBuddy(),
            systemImage: "takeoutbag.and.cup.and.straw.fill"
        )
    }
}
