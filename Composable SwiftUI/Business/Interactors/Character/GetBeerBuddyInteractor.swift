import Resolver

protocol GetBeerBuddyInteractor {
    func execute(character: Character) async throws -> BeerBuddy?
}

final class GetBeerBuddyInteractorDefault: GetBeerBuddyInteractor, ManagedErrorInteractor {
    
    @Injected private var locationRepository: LocationRepository
    @Injected private var charactersRepository: CharactersRepository
    @Injected private var episodesRepository: EpisodesRepository
    
    func execute(character: Character) async throws -> BeerBuddy? {
        do {
            let response = try await locationRepository.getCharacterIdsFromLocation(locationId: character.location.id)
            let characterIds = response.filter({ $0 != character.id })
            
            // TODO: JLI improve read code
            if characterIds.isEmpty {
                return nil
            }
            
            let characters = try await getCharactersFromIds(characterIds: characterIds)
            
            return try await getBestBuddyBeer(selectedCharacter: character, buddiesFromLocation: characters)
            
        } catch {
            throw manageError(error: error)
        }
    }
    
    private func getCharactersFromIds(characterIds: [Int]) async throws -> [Character] {
        try await charactersRepository.getCharacters(characterIds: characterIds)
    }
    
    private func getBestBuddyBeer(
        selectedCharacter: Character,
        buddiesFromLocation: [Character]) async throws -> BeerBuddy? {
            let matchedEpisodesList = buddiesFromLocation
                .compactMap {
                    $0.matchedEpisodes(with: selectedCharacter)
                }
                .sorted()
            
            return try await buildBestBuddy(
                matchedEpisodesList: matchedEpisodesList,
                selectedCharacter: selectedCharacter
            )
        }
    
    private func buildBestBuddy(
        matchedEpisodesList: [MatchedEpisodes],
        selectedCharacter: Character
    ) async throws -> BeerBuddy? {
        guard let bestBuddy = matchedEpisodesList.first else {
            return nil
        }
        let response = try await episodesRepository.getEpisodesFromList(
            ids: [bestBuddy.firstEpisode, bestBuddy.lastEpisode]
        )
        
        let episodes = response.sorted(by: { $0.id < $1.id })
        
        guard let firstEpisode = episodes.first,
              let lastEpisode = episodes.last else {
            return nil
        }
        
        return BeerBuddy(
            count: bestBuddy.count,
            buddy: bestBuddy.character,
            character: selectedCharacter,
            firstEpisode: firstEpisode,
            lastEpisode: lastEpisode
        )
    }
}
