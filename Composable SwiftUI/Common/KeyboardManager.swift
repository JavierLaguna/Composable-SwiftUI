import IQKeyboardManagerSwift

struct KeyboardManager {

    @MainActor static func configureKeyboardBehaviour() {
        IQKeyboardManager.shared.isEnabled = true
    }
}
