import SwiftUI
import ComposableArchitecture

struct MainView: View {

    let mainStore: StoreOf<MainReducer>

    @State private var mainCoordinator = MainCoordinator()
    @State private var charactersCoordinator: CharactersCoordinator

    init(mainStore: StoreOf<MainReducer>) {
        self.mainStore = mainStore
        charactersCoordinator = CharactersCoordinator(mainStore: mainStore)
    }

    var body: some View {
        TabView(selection: mainCoordinator.tabSelectionBinding) {

            NavigationStack(path: charactersCoordinator.pathBinding) {
                CharactersCoordinator.Routes
                    .root(mainStore)
                    .navigationDestination(for: CharactersCoordinator.Routes.self) { $0 }
            }
            .tabItem {
                Label(
                    R.string.localizable.tabBarCharacters(),
                    systemImage: "person.fill"
                )
            }
            .tag(MainCoordinator.Tab.characters.rawValue)

            NavigationStack {
                EpisodesCoordinator.Routes
                    .root
                    .navigationDestination(for: EpisodesCoordinator.Routes.self) { $0 }
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
