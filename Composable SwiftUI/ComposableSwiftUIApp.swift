import SwiftUI

@main
struct ComposableSwiftUIApp: App {

    init() {
        Theme.configureNavigationBarAppareance()
        KeyboardManager.configureKeyboardBehaviour()
    }

    var body: some Scene {
        WindowGroup {
            MainCoordinator.RootView()
        }
    }
}
