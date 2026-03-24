import SwiftUI
import ComposableArchitecture

struct MainView: View {

    let mainStore: StoreOf<MainReducer>

    @State private var mainCoordinator = MainCoordinator()
    @State private var charactersCoordinator: CharactersCoordinator
    @State private var episodesCoordinator: EpisodesCoordinator
    @State private var locationsCoordinator: LocationsCoordinator

    init(mainStore: StoreOf<MainReducer>) {
        self.mainStore = mainStore
        charactersCoordinator = CharactersCoordinator(mainStore: mainStore)
        episodesCoordinator = EpisodesCoordinator()
        locationsCoordinator = LocationsCoordinator()
    }

    var body: some View {
        MainTabView(
            selectedTab: mainCoordinator.tabSelectionBinding
        )
        .environment(mainCoordinator)
        .environment(charactersCoordinator)
        .environment(episodesCoordinator)
        .environment(locationsCoordinator)
    }
}

#Preview {

    let mainStore = StoreOf<MainReducer>(
        initialState: .init(),
        reducer: {
            MainReducer()
        }
    )

    MainView(mainStore: mainStore)
}
