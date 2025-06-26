protocol GetTotalCharactersCountInteractor: Sendable {
    func execute() async throws -> Int
}

struct GetTotalCharactersCountInteractorFactory {

    static func build() -> any GetTotalCharactersCountInteractor {
        GetTotalCharactersCountInteractorDefault(
            repository: CharactersRepositoryFactory.build()
        )
    }
}

struct GetTotalCharactersCountInteractorDefault: GetTotalCharactersCountInteractor, ManagedErrorInteractor {

    let repository: any CharactersRepository

    func execute() async throws -> Int {
        do {
            let totalCharactersCount = try await repository.getTotalCharactersCount()
            return totalCharactersCount

        } catch {
            throw manageError(error: error)
        }
    }
}
