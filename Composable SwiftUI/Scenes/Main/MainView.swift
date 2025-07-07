import SwiftUI
import ComposableArchitecture

struct MainView: View {

    let mainStore: StoreOf<MainReducer>

    @State private var mainCoordinator = MainCoordinator()
    @State private var charactersCoordinator: CharactersCoordinator
    @State private var episodesCoordinator: EpisodesCoordinator

    init(mainStore: StoreOf<MainReducer>) {
        self.mainStore = mainStore
        charactersCoordinator = CharactersCoordinator(mainStore: mainStore)
        episodesCoordinator = EpisodesCoordinator()
    }

    var body: some View {
        TabView(selection: mainCoordinator.tabSelectionBinding) {

            NavigationStack(path: charactersCoordinator.pathBinding) {
                charactersCoordinator
                    .view(for: .root)
                    .navigationDestination(for: CharactersCoordinator.Routes.self) {
                        charactersCoordinator.view(for: $0)
                    }
                    .sheet(isPresented: charactersCoordinator.sheetIsPresented) {
                        charactersCoordinator.sheet
                    }
            }
            .tabItem {
                Label(
                    R.string.localizable.tabBarCharacters(),
                    systemImage: "person.fill"
                )
            }
            .tag(MainCoordinator.Tab.characters.rawValue)

            NavigationStack(path: episodesCoordinator.pathBinding) {
                episodesCoordinator
                    .view(for: .root)
                    .navigationDestination(for: EpisodesCoordinator.Routes.self) {
                        episodesCoordinator.view(for: $0)
                    }
                    .sheet(isPresented: episodesCoordinator.sheetIsPresented) {
                        episodesCoordinator.sheet
                    }
            }
            .tabItem {
                Label(
                    R.string.localizable.tabBarEpisodes(),
                    systemImage: "number.square.fill"
                )
            }
            .tag(MainCoordinator.Tab.episodes.rawValue)

            NavigationStack {
                Text("TODO: LOCATIONS")
            }
            .tabItem {
                Label(
                    R.string.localizable.tabBarLocations(),
                    systemImage: "signpost.right.and.left.fill"
                )
            }
            .tag(MainCoordinator.Tab.locations.rawValue)
        }
        .environment(mainCoordinator)
        .environment(charactersCoordinator)
        .environment(episodesCoordinator)
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
