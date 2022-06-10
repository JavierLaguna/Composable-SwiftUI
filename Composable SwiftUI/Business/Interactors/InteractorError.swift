enum InteractorError: Error, Equatable {
    case generic(message: String?)
    case repositoryFail(error: RepositoryError)
}
