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
        TabView(selection: mainCoordinator.tabSelectionBinding) {
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
