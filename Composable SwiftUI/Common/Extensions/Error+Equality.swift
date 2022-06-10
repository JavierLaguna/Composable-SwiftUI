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
        let lhs = self as Error
        let rhs = other as Error
        return isEqual(other) && lhs.reflectedString == rhs.reflectedString
    }
}

class ErrorUtility {
    public static func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
        return lhs.reflectedString == rhs.reflectedString
    }
}
