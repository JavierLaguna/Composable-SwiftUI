enum CharacterGender: String, Equatable, Hashable, CaseIterable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"

    var localizedDescription: String {
        switch self {
        case .female:
            return R.string.localizable.characterGenderFemale()
        case .male:
            return R.string.localizable.characterGenderMale()
        case .genderless:
            return R.string.localizable.characterGenderGenderless()
        case .unknown:
            return R.string.localizable.characterGenderUnknown()
        }
    }
}
