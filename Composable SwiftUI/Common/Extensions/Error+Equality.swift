import Foundation

extension Error {
    public var reflectedString: String {
        return String(reflecting: self)
    }

    public func isEqual(to other: Self) -> Bool {
        return reflectedString == other.reflectedString
    }
}

extension NSError {
    public func isEqual(to other: NSError) -> Bool {
        let lhs = self as (any Error)
        let rhs = other as (any Error)
        return isEqual(other) && lhs.reflectedString == rhs.reflectedString
    }
}

final class ErrorUtility {
    public static func areEqual(_ lhs: any Error, _ rhs: any Error) -> Bool {
        return lhs.reflectedString == rhs.reflectedString
    }
}
