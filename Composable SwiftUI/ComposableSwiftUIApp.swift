import SwiftUI

@main
struct ComposableSwiftUIApp: App {

    init() {
        KeyboardManager.configureKeyboardBehaviour()
    }

    var body: some Scene {
        WindowGroup {
            MainView() // TODO: Main Coordinator ???
        }
    }
}
