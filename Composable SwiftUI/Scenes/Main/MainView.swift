import SwiftUI

struct MainView: View {

    @State private var mainCoordinator = MainCoordinator()
    @State private var charactersCoordinator = CharactersCoordinator()

    var body: some View {
        TabView(selection: mainCoordinator.tabSelectionBinding) {

            NavigationStack(path: charactersCoordinator.pathBinding) {
                CharactersCoordinator.Routes.root
                    .navigationDestination(for: CharactersCoordinator.Routes.self) { $0 }
            }
            .tabItem {
                Label(
                    R.string.localizable.tabBarNeighbors(),
                    systemImage: "person.fill"
                )
            }
            .tag(MainCoordinator.Tab.characters.rawValue)

        }
    }
}

#Preview {
    MainView()
}
