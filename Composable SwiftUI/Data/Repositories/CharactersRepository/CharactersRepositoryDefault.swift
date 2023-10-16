import Resolver

final class CharactersRepositoryDefault: CharactersRepository {

    @Injected private var service: CharacterRemoteDatasource

    private(set) var nextPage: Int?
    private(set) var totalPages: Int?

    func getCharacters() async throws -> [Character] {

        if let nextPage, let totalPages, nextPage > totalPages {
            return []
        }

        let response = try await service.getCharacters(page: nextPage)

        if let nextPage {
            self.nextPage = nextPage + 1
        } else {
            nextPage = 2
        }

        totalPages = response.info.pages

        return response.results.map { $0.toDomain() }
    }

    func getCharacters(characterIds: [Int]) async throws -> [Character] {
        try await service.getCharacters(by: characterIds)
            .map { $0.toDomain() }
    }
}
