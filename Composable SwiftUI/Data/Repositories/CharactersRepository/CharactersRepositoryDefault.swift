actor CharactersRepositoryDefault: CharactersRepository {

    private let service: any CharacterRemoteDatasource
    private(set) var nextPage: Int?
    private(set) var totalPages: Int?
    private(set) var totalCharacters: Int?

    init(service: any CharacterRemoteDatasource) {
        self.service = service
    }

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
        totalCharacters = response.info.count

        return response.results.map { $0.toDomain() }
    }

    func getCharacter(characterId: Int) async throws -> Character {
        let characters = try await service.getCharacters(by: [characterId])

        guard let character = characters.first?.toDomain() else {
            throw RepositoryError.invalidParameters
        }

        return character
    }

    func getCharacters(characterIds: [Int]) async throws -> [Character] {
        try await service.getCharacters(by: characterIds)
            .map { $0.toDomain() }
    }

    func getTotalCharactersCount() async throws -> Int {
        if let totalCharacters {
            return totalCharacters

        } else {
            let response = try await service.getCharacters(page: nextPage)
            totalCharacters = response.info.count
            return response.info.count
        }
    }
}
