import SwiftUI

struct MainTabView: View {

    @Binding var selectedTab: Int

    @Environment(CharactersCoordinator.self)
    private var charactersCoordinator

    @Environment(EpisodesCoordinator.self)
    private var episodesCoordinator

    @Environment(LocationsCoordinator.self)
    private var locationsCoordinator

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                R.string.localizable.tabBarCharacters(),
                systemImage: "person.fill",
                value: MainCoordinator.Tab.characters.rawValue
            ) {
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
            }

            Tab(
                R.string.localizable.tabBarEpisodes(),
                systemImage: "number.square.fill",
                value: MainCoordinator.Tab.episodes.rawValue
            ) {
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
            }

            Tab(
                R.string.localizable.tabBarLocations(),
                systemImage: "signpost.right.and.left.fill",
                value: MainCoordinator.Tab.locations.rawValue
            ) {
                NavigationStack(path: locationsCoordinator.pathBinding) {
                    locationsCoordinator
                        .view(for: .root)
                        .navigationDestination(for: LocationsCoordinator.Routes.self) {
                            locationsCoordinator.view(for: $0)
                        }
                        .sheet(isPresented: locationsCoordinator.sheetIsPresented) {
                            locationsCoordinator.sheet
                        }
                }
            }
        }
        .tint(Theme.Colors.primary)
    }
}

#Preview {
    MainTabView(
        selectedTab: .constant(1)
    )
    .allEnvironmentsInjected
}
