struct StateLoadable<T: Equatable> {

    enum State {
        case initial
        case loading
        case populated(data: T)
        case empty
        case error(Error)

        indirect case previous (State)
    }

    private(set)var data: T?
    private(set)var error: Error?

    var state: State = .initial {
        didSet {
            stateDidUpdated()
        }
    }

    var isLoading: Bool {
        state == .loading
    }

    var isEmpty: Bool {
        state == .empty
    }

    init() {
        // Intentionally unimplemented
    }

    init(state: State) {
        self.state = state

        stateDidUpdated()
    }

    private mutating func stateDidUpdated() {
        if case let .error(newError) = state {
            error = newError
        } else {
            error = nil

            if case let .populated(newData) = state {
                data = newData
            }
        }
    }
}

extension StateLoadable: Equatable {

    static func == (lhs: StateLoadable<T>, rhs: StateLoadable<T>) -> Bool {

        var errorsAreEqual: Bool

        if let lhsError = lhs.error, let rhsError = rhs.error {
            errorsAreEqual = ErrorUtility.areEqual(lhsError, rhsError)

        } else if lhs.error == nil, rhs.error == nil {
            errorsAreEqual = true

        } else {
            errorsAreEqual = false
        }

        return errorsAreEqual &&
        lhs.state == rhs.state &&
        lhs.data == rhs.data
    }
}

extension StateLoadable.State: Equatable {

    static func == (lhs: StateLoadable<T>.State, rhs: StateLoadable<T>.State) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial),
            (.empty, .empty),
            (.loading, .loading):
            return true

        case (.populated(let lhsData), .populated(let rhsData)):
            return lhsData == rhsData

        case (.error(let lhsError), .error(let rhsError)):
            return ErrorUtility.areEqual(lhsError, rhsError)

        default:
            return false
        }
    }
}
