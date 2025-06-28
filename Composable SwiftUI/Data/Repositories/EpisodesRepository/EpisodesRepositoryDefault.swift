actor EpisodesRepositoryDefault: EpisodesRepository {

    private let service: any EpisodesRemoteDatasource
    private(set) var nextPage: Int?
    private(set) var totalPages: Int?

    init(service: any EpisodesRemoteDatasource) {
        self.service = service
    }

    func getEpisodes() async throws -> [Episode] {
        if let nextPage, let totalPages, nextPage > totalPages {
            return []
        }

        let response = try await service.getEpisodes(page: nextPage)

        if let nextPage {
            self.nextPage = nextPage + 1
        } else {
            nextPage = 2
        }

        totalPages = response.info.pages

        return response.results.map { $0.toDomain() }
    }

    func getEpisodesFromList(ids: [Int]) async throws -> [Episode] {
        let response = try await service.getEpisodesList(ids: ids)
        return response.compactMap { $0.toDomain() }
    }
}
