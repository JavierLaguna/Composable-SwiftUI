enum CharacterStatus: String, Equatable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"

    var localizedDescription: String {
        switch self {
        case .alive:
            return R.string.localizable.characterStatusAlive()
        case .dead:
            return R.string.localizable.characterStatusDead()
        case .unknown:
            return R.string.localizable.characterStatusUnknown()
        }
    }
}
