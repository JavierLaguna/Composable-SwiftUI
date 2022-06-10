import Combine
import Resolver

protocol GetBeerBuddyInteractor {
    func execute(character: Character) -> AnyPublisher<BeerBuddy?, InteractorError>
}

final class GetBeerBuddyInteractorDefault: GetBeerBuddyInteractor {
    
    @Injected private var locationRepository: LocationRepository
    @Injected private var charactersRepository: CharactersRepository
    @Injected private var episodesRepository: EpisodesRepository
    
    private let beerBuddyNotFoundMsgError = "kBeerBuddyNotFoundMsgError"
    
    func execute(character: Character) -> AnyPublisher<BeerBuddy?, InteractorError> {
        
        return locationRepository
            .getCharacterIdsFromLocation(locationId: character.location.id)
            .mapError { error -> InteractorError in
                    .repositoryFail(error: error)
            }
            .flatMap { response -> AnyPublisher<[Character], InteractorError> in
                let characterIds = response.filter({ $0 != character.id })
                
                if characterIds.isEmpty {
                    return Fail<[Character], InteractorError>(error: .generic(message: self.beerBuddyNotFoundMsgError))
                        .eraseToAnyPublisher()
                }
                
                return self.getCharactersFromIds(characterIds: characterIds)
            }
            .flatMap { response -> AnyPublisher<BeerBuddy?, InteractorError> in self.getBestBuddyBeer(selectedCharacter: character, buddiesFromLocation: response)
            }
            .catch { error -> AnyPublisher<BeerBuddy?, InteractorError> in
                if case let .generic(errorMsg) = error,
                   errorMsg == self.beerBuddyNotFoundMsgError {
                    return Just(nil)
                        .setFailureType(to: InteractorError.self)
                        .eraseToAnyPublisher()
                }
                
                return Fail<BeerBuddy?, InteractorError>(error: error)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getCharactersFromIds(characterIds: [Int]) -> AnyPublisher<[Character], InteractorError> {
        
        return charactersRepository
            .getCharacters(characterIds: characterIds)
            .catch { error -> AnyPublisher<[Character], InteractorError> in
                return Fail<[Character], InteractorError>(error: .repositoryFail(error: error))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getBestBuddyBeer(
        selectedCharacter: Character,
        buddiesFromLocation: [Character]) -> AnyPublisher<BeerBuddy?, InteractorError> {
            let matchedEpisodesList = buddiesFromLocation
                .compactMap {
                    $0.matchedEpisodes(with: selectedCharacter)
                }
                .sorted()
            
            return buildBestBuddy(
                matchedEpisodesList: matchedEpisodesList,
                selectedCharacter: selectedCharacter
            )
        }
    
    private func buildBestBuddy(
        matchedEpisodesList: [MatchedEpisodes],
        selectedCharacter: Character
    ) -> AnyPublisher<BeerBuddy?, InteractorError> {
        guard let bestBuddy = matchedEpisodesList.first else {
            return Just(nil)
                .setFailureType(to: InteractorError.self)
                .eraseToAnyPublisher()
        }
        
        return episodesRepository.getEpisodesFromList(
            ids: [bestBuddy.firstEpisode, bestBuddy.lastEpisode]
        )
        .mapError { error -> InteractorError in
                .repositoryFail(error: error)
        }
        .map { response -> BeerBuddy? in
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
        .eraseToAnyPublisher()
    }
}
