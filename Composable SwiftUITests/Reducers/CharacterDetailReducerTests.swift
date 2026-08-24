import Foundation
import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "CharacterDetailReducer",
    .tags(.reducer)
)
struct CharacterDetailReducerTests {

    @Test
    func getCharacterDescription_whenInteractorFail_returnsInteractorError() async {
        let mockGetCharactersInteractor = MockGetCharactersInteractor()
        let mockGetCharacterDescriptionInteractor = MockGetCharacterDescriptionInteractor()
        let mockGetTotalCharactersCountInteractor = MockGetTotalCharactersCountInteractor()
        let mockGetEpisodesInteractor = MockGetEpisodesInteractor()

        let mockError = InteractorError.generic(message: "mock error")

        given(mockGetCharacterDescriptionInteractor)
            .execute(character: .any)
            .willThrow(mockError)

        let store = await TestStore(
            initialState: .init(
                character: Character.mock,
                viewMode: .allInfo
            ),
            reducer: {
                CharacterDetailReducer(
                    getCharactersInteractor: mockGetCharactersInteractor,
                    getCharacterDescriptionInteractor: mockGetCharacterDescriptionInteractor,
                    getTotalCharactersCountInteractor: mockGetTotalCharactersCountInteractor,
                    getEpisodesByIdsInteractor: mockGetEpisodesInteractor
                )
            }
        )

        await store.send(.getCharacterDescription) {
            $0.characterDescription.state = .loading
        }

        await store.receive(\.onReceiveCharacterDescription.failure) {
            $0.characterDescription.state = .error(mockError)
        }

        verify(mockGetCharacterDescriptionInteractor)
            .execute(character: .value(Character.mock))
            .called(.once)

        verify(mockGetCharactersInteractor)
            .execute()
            .called(.never)

        verify(mockGetCharactersInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockGetCharactersInteractor)
            .execute(ids: .any)
            .called(.never)

        verify(mockGetTotalCharactersCountInteractor)
            .execute()
            .called(.never)

        verify(mockGetEpisodesInteractor)
            .execute(ids: .any)
            .called(.never)
    }

    @Test
    func getCharacterDescription_whenNavigatingNext_cancelsInFlightRequest() async {
        let gate = Gate()
        let mockGetCharactersInteractor = MockGetCharactersInteractor()
        let hangingDescriptionInteractor = HangingDescriptionInteractor(
            gate: gate,
            result: "morty description"
        )
        let mockGetTotalCharactersCountInteractor = MockGetTotalCharactersCountInteractor()
        let mockGetEpisodesInteractor = MockGetEpisodesInteractor()
        let morty = Character.morty
        let expectedEpisodes = Episode.mocks

        given(mockGetCharactersInteractor)
            .execute(id: .value(2))
            .willReturn(morty)

        given(mockGetTotalCharactersCountInteractor)
            .execute()
            .willReturn(826)

        given(mockGetEpisodesInteractor)
            .execute(ids: .any)
            .willReturn(expectedEpisodes)

        var initialState = CharacterDetailReducer.State(
            character: Character.rick,
            viewMode: .allInfo
        )
        initialState.totalCharactersCount = 826

        let store = await TestStore(
            initialState: initialState,
            reducer: {
                CharacterDetailReducer(
                    getCharactersInteractor: mockGetCharactersInteractor,
                    getCharacterDescriptionInteractor: hangingDescriptionInteractor,
                    getTotalCharactersCountInteractor: mockGetTotalCharactersCountInteractor,
                    getEpisodesByIdsInteractor: mockGetEpisodesInteractor
                )
            }
        )

        await store.send(.getCharacterDescription) {
            $0.characterDescription.state = .loading
        }

        await store.send(.seeNextCharacter) {
            $0.currentCharacter.state = .loading
            $0.characterDescription.state = .empty
        }

        await store.receive(\.onReceiveNewCharacter.success) {
            $0.currentCharacter.state = .populated(data: morty)
        }

        await store.receive(\.getEpisodes) {
            $0.episodes.state = .loading
        }

        await store.receive(\.getCharacterDescription) {
            $0.characterDescription.state = .loading
        }

        await store.receive(\.onReceiveEpisodes.success) {
            $0.episodes.state = .populated(data: expectedEpisodes)
        }

        gate.open()

        await store.receive(\.onReceiveCharacterDescription.success) {
            $0.characterDescription.state = .populated(data: "morty description")
            $0.currentCharacter.state = .populated(data: morty.copy(description: "morty description"))
        }

        #expect(hangingDescriptionInteractor.didObserveCancellation)

        verify(mockGetCharactersInteractor)
            .execute(id: .value(2))
            .called(.once)

        verify(mockGetEpisodesInteractor)
            .execute(ids: .any)
            .called(.once)
    }

    @Test
    func getEpisodes_whenNavigatingPrevious_cancelsInFlightRequest() async {
        let gate = Gate()
        let mockGetCharactersInteractor = MockGetCharactersInteractor()
        let mockGetCharacterDescriptionInteractor = MockGetCharacterDescriptionInteractor()
        let mockGetTotalCharactersCountInteractor = MockGetTotalCharactersCountInteractor()
        let hangingEpisodesInteractor = HangingEpisodesInteractor(
            gate: gate,
            episodes: Episode.mocks
        )
        let rick = Character.rick

        given(mockGetCharactersInteractor)
            .execute(id: .value(1))
            .willReturn(rick)

        given(mockGetTotalCharactersCountInteractor)
            .execute()
            .willReturn(826)

        given(mockGetCharacterDescriptionInteractor)
            .execute(character: .any)
            .willReturn("rick description")

        var initialState = CharacterDetailReducer.State(
            character: Character.morty,
            viewMode: .allInfo
        )
        initialState.totalCharactersCount = 826

        let store = await TestStore(
            initialState: initialState,
            reducer: {
                CharacterDetailReducer(
                    getCharactersInteractor: mockGetCharactersInteractor,
                    getCharacterDescriptionInteractor: mockGetCharacterDescriptionInteractor,
                    getTotalCharactersCountInteractor: mockGetTotalCharactersCountInteractor,
                    getEpisodesByIdsInteractor: hangingEpisodesInteractor
                )
            }
        )

        await store.send(.getEpisodes) {
            $0.episodes.state = .loading
        }

        await store.send(.seePreviousCharacter) {
            $0.currentCharacter.state = .loading
            $0.characterDescription.state = .empty
        }

        await store.receive(\.onReceiveNewCharacter.success) {
            $0.currentCharacter.state = .populated(data: rick)
        }

        await store.receive(\.getEpisodes)

        await store.receive(\.getCharacterDescription) {
            $0.characterDescription.state = .loading
        }

        await store.receive(\.onReceiveCharacterDescription.success) {
            $0.characterDescription.state = .populated(data: "rick description")
            $0.currentCharacter.state = .populated(data: rick.copy(description: "rick description"))
        }

        gate.open()

        await store.receive(\.onReceiveEpisodes.success) {
            $0.episodes.state = .populated(data: Episode.mocks)
        }

        #expect(hangingEpisodesInteractor.didObserveCancellation)

        verify(mockGetCharactersInteractor)
            .execute(id: .value(1))
            .called(.once)

        verify(mockGetCharacterDescriptionInteractor)
            .execute(character: .any)
            .called(.once)
    }
}

// MARK: Test doubles

private final class Gate: @unchecked Sendable {

    private let lock = NSLock()
    private var continuation: CheckedContinuation<Void, Never>?
    private var isOpen = false

    func wait() async {
        await withCheckedContinuation { continuation in
            lock.lock()
            defer { lock.unlock() }

            if isOpen {
                continuation.resume(returning: ())
            } else {
                self.continuation = continuation
            }
        }
    }

    func open() {
        lock.lock()
        defer { lock.unlock() }

        isOpen = true
        if let continuation {
            self.continuation = nil
            continuation.resume(returning: ())
        }
    }
}

private final class HangingDescriptionInteractor: GetCharacterDescriptionInteractor, @unchecked Sendable {

    private let lock = NSLock()
    private let gate: Gate
    private let result: String
    private var callCount = 0
    private var observedCancellation = false

    init(gate: Gate, result: String) {
        self.gate = gate
        self.result = result
    }

    var didObserveCancellation: Bool {
        lock.lock()
        defer { lock.unlock() }
        return observedCancellation
    }

    func execute(character: Character) async throws -> String {
        if markFirstCall() {
            do {
                try await Task.sleep(for: .seconds(60))
            } catch {
                recordCancellation()
                throw error
            }
        } else {
            await gate.wait()
        }

        return result
    }

    private func markFirstCall() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        callCount += 1
        return callCount == 1
    }

    private func recordCancellation() {
        lock.lock()
        defer { lock.unlock() }
        observedCancellation = true
    }
}

private final class HangingEpisodesInteractor: GetEpisodesInteractor, @unchecked Sendable {

    private let lock = NSLock()
    private let gate: Gate
    private let episodes: [Episode]
    private var callCount = 0
    private var observedCancellation = false

    init(gate: Gate, episodes: [Episode]) {
        self.gate = gate
        self.episodes = episodes
    }

    var didObserveCancellation: Bool {
        lock.lock()
        defer { lock.unlock() }
        return observedCancellation
    }

    func execute() async throws -> [Episode] {
        episodes
    }

    func execute(id: Int) async throws -> Episode {
        guard let episode = episodes.first else {
            throw InteractorError.generic(message: "Empty response")
        }

        return episode
    }

    func execute(ids: [Int]) async throws -> [Episode] {
        if markFirstCall() {
            do {
                try await Task.sleep(for: .seconds(60))
            } catch {
                recordCancellation()
                throw error
            }
        } else {
            await gate.wait()
        }

        return episodes
    }

    private func markFirstCall() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        callCount += 1
        return callCount == 1
    }

    private func recordCancellation() {
        lock.lock()
        defer { lock.unlock() }
        observedCancellation = true
    }
}
