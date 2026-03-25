import Foundation
import FoundationModels

enum AppleIntelligenceNotAvailableError: Error, LocalizedError {
    case deviceNotEligible
    case appleIntelligenceNotEnabled
    case modelNotReady
    case other(String)

    var errorDescription: String? {
        switch self {
        case .deviceNotEligible:
            R.string.localizable.appleIntelligenceNotAvailableErrorDeviceNotEligible()
        case .appleIntelligenceNotEnabled:
            R.string.localizable.appleIntelligenceNotAvailableErrorAppleIntelligenceNotEnabled()
        case .modelNotReady:
            R.string.localizable.appleIntelligenceNotAvailableErrorModelNotReady()
        case .other(let reason):
            R.string.localizable.appleIntelligenceNotAvailableErrorOther(reason)
        }
    }

    @available(iOS 26.0, *)
    init(from: SystemLanguageModel.Availability) {
        switch from {
        case .available:
            self = .other("WTF this feature is available!")
        case .unavailable(.deviceNotEligible):
            self = .deviceNotEligible
        case .unavailable(.appleIntelligenceNotEnabled):
            self = .appleIntelligenceNotEnabled
        case .unavailable(.modelNotReady):
            self = .modelNotReady
        case .unavailable(let other):
            self = .other("\(other)")
        }
    }
}
