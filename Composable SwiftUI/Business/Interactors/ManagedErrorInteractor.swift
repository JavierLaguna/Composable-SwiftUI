protocol ManagedErrorInteractor {
    func manageError(error: any Error) -> any Error
}

extension ManagedErrorInteractor {

    func manageError(error: any Error) -> any Error {
        guard let repositoryError = error as? RepositoryError else {
            return error
        }

        return InteractorError.repositoryFail(error: repositoryError)
    }
}
