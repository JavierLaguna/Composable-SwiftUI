import SwiftUI

struct MainView: View {

    @State private var mainCoordinator = MainCoordinator()
    @State private var charactersCoordinator = CharactersCoordinator()

    var body: some View {
        TabView(selection: mainCoordinator.tabSelectionBinding) {

            NavigationStack(path: charactersCoordinator.pathBinding) {
                CharactersCoordinator.Routes
                    .root
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
                Text("TODO: EPISODES")
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
    MainView()
}
