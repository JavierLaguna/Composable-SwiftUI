import SwiftUI
import ComposableArchitecture

extension View {

    var allEnvironmentsInjected: some View {
        self.modifier(
            AllEnvironmentsInjectedModifier()
        )
    }
}

private struct AllEnvironmentsInjectedModifier: ViewModifier {

    private let mainStore: StoreOf<MainReducer>

    @State private var mainCoordinator = MainCoordinator()
    @State private var charactersCoordinator: CharactersCoordinator

    init() {
        mainStore = StoreOf<MainReducer>(
            initialState: .init(),
            reducer: {
                MainReducer()
            }
        )

        charactersCoordinator = CharactersCoordinator(mainStore: mainStore)
    }

    func body(content: Content) -> some View {
        content
            .environment(mainCoordinator)
            .environment(charactersCoordinator)
    }
}
