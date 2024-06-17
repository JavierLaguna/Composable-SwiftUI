import SwiftUI

import Stinsen

import Resolver
import ComposableArchitecture

@main
struct ComposableSwiftUIApp: App {

    @State private var coordinator = CharactersListCoordinator()

    init() {
        KeyboardManager.configureKeyboardBehaviour()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: coordinator.pathBinding) {
                CharactersListCoordinator.Routes.root
                    .navigationDestination(for: CharactersListCoordinator.Routes.self) { $0 }
            }
        }
    }
}
