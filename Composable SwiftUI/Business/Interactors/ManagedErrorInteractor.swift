
protocol ManagedErrorInteractor {
    func manageError(error: Error) -> Error
}

extension ManagedErrorInteractor {
    
    func manageError(error: Error) -> Error {
        guard let repositoryError = error as? RepositoryError else {
            return error
        }
        
        return InteractorError.repositoryFail(error: repositoryError)
    }
}
