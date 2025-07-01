import SwiftUI
import Observation

@Observable
class Coordinator<Route: Hashable, SheetType: Hashable>: ObservableObject {
    
    private(set) var path: [Route] = []
    private(set) var sheet: SheetType?

    @MainActor
    var pathBinding: Binding<[Route]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    @MainActor
    var sheetIsPresented: Binding<Bool> {
        Binding(
            get: { self.sheet != nil },
            set: { self.sheet = $0 ? self.sheet : nil }
        )
    }

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func present(_ sheet: SheetType) {
        self.sheet = sheet
    }

    func dismissSheet() {
        sheet = nil
    }
}
