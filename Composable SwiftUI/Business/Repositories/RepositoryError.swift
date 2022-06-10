enum RepositoryError: Error {
    case invalidUrl
    case invalidParameters
    case serviceFail(error: Error)
}

extension RepositoryError: Equatable {
    
    static func == (lhs: RepositoryError, rhs: RepositoryError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
            
        case (.invalidParameters, .invalidParameters):
            return true
            
        case (.serviceFail(let lhsError), .serviceFail(let rhsError)):
            return ErrorUtility.areEqual(lhsError, rhsError)
            
        default:
            return false
        }
    }
}
