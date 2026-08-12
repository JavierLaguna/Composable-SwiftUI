import Foundation
import Testing
@testable import Composable_SwiftUI

@Suite(
    "GetCharacterDescriptionInteractorByAppleIntelligence",
    .tags(.interactor)
)
struct CharacterDescriptionInteractorTests {

    @Test
    func execute_whenNotAvailable_throwsNotAvailableError() async {
        if #available(iOS 26.0, *) {
            let recorder = SessionRecorder()
            let client = CharacterDescriptionSessionClient(
                isResponding: { true },
                respond: { prompt in
                    recorder.recordRespond(to: prompt)
                    return CharacterDescription(text: "should not happen")
                }
            )
            let interactor = GetCharacterDescriptionInteractorByAppleIntelligence(
                sessionClient: client,
                isAvailableOverride: false
            )

            await #expect(throws: AppleIntelligenceNotAvailableError.self) {
                try await interactor.execute(character: Character.rick)
            }

            #expect(recorder.respondCallCount == 0)
        }
    }

    @Test
    func execute_whenSessionIsResponding_waitsBeforeResponding() async throws {
        if #available(iOS 26.0, *) {
            let clock = ContinuousClock()
            let start = clock.now
            let recorder = SessionRecorder()
            let client = CharacterDescriptionSessionClient(
                isResponding: { true },
                respond: { prompt in
                    recorder.recordRespond(to: prompt)
                    return CharacterDescription(text: "fake description")
                }
            )
            let interactor = GetCharacterDescriptionInteractorByAppleIntelligence(
                sessionClient: client,
                waitDuration: .milliseconds(100),
                isAvailableOverride: true
            )

            let result = try await interactor.execute(character: Character.rick)

            let elapsed = start.duration(to: clock.now)
            #expect(result == "fake description")
            #expect(elapsed >= .milliseconds(50))
            #expect(recorder.respondCallCount == 1)
        }
    }

    @Test
    func execute_whenCancelledWhileWaitingForSession_throwsCancellationError() async throws {
        if #available(iOS 26.0, *) {
            let recorder = SessionRecorder()
            let client = CharacterDescriptionSessionClient(
                isResponding: { true },
                respond: { prompt in
                    recorder.recordRespond(to: prompt)
                    return CharacterDescription(text: "should not happen")
                }
            )
            let interactor = GetCharacterDescriptionInteractorByAppleIntelligence(
                sessionClient: client,
                waitDuration: .seconds(60),
                isAvailableOverride: true
            )

            let task = Task {
                try await interactor.execute(character: Character.rick)
            }

            try await Task.sleep(for: .milliseconds(50))
            task.cancel()

            await #expect(throws: CancellationError.self) {
                try await task.value
            }

            #expect(recorder.respondCallCount == 0)
        }
    }

    @Test
    func execute_whenCancelledBeforeResponding_throwsCancellationError() async throws {
        if #available(iOS 26.0, *) {
            let recorder = SessionRecorder()
            let client = CharacterDescriptionSessionClient(
                isResponding: {
                    recorder.spinUntilCancelled()
                    return false
                },
                respond: { prompt in
                    recorder.recordRespond(to: prompt)
                    return CharacterDescription(text: "should not happen")
                }
            )
            let interactor = GetCharacterDescriptionInteractorByAppleIntelligence(
                sessionClient: client,
                isAvailableOverride: true
            )

            let task = Task {
                try await interactor.execute(character: Character.rick)
            }

            try await Task.sleep(for: .milliseconds(50))
            task.cancel()

            await #expect(throws: CancellationError.self) {
                try await task.value
            }

            #expect(recorder.respondCallCount == 0)
        }
    }

    @Test
    func execute_whenCancelledDuringResponding_throwsCancellationError() async throws {
        if #available(iOS 26.0, *) {
            let recorder = SessionRecorder()
            let client = CharacterDescriptionSessionClient(
                isResponding: { false },
                respond: { prompt in
                    recorder.recordRespond(to: prompt)
                    try await Task.sleep(for: .seconds(60))
                    return CharacterDescription(text: "should not happen")
                }
            )
            let interactor = GetCharacterDescriptionInteractorByAppleIntelligence(
                sessionClient: client,
                isAvailableOverride: true
            )

            let task = Task {
                try await interactor.execute(character: Character.rick)
            }

            try await Task.sleep(for: .milliseconds(50))
            task.cancel()

            await #expect(throws: CancellationError.self) {
                try await task.value
            }

            #expect(recorder.respondCallCount == 1)
        }
    }

    @Test
    func execute_whenCancelledAfterRespondingCompletes_throwsCancellationError() async throws {
        if #available(iOS 26.0, *) {
            let recorder = SessionRecorder()
            let client = CharacterDescriptionSessionClient(
                isResponding: { false },
                respond: { prompt in
                    recorder.recordRespond(to: prompt)
                    recorder.spinUntilCancelled()
                    return CharacterDescription(text: "late response")
                }
            )
            let interactor = GetCharacterDescriptionInteractorByAppleIntelligence(
                sessionClient: client,
                isAvailableOverride: true
            )

            let task = Task {
                try await interactor.execute(character: Character.rick)
            }

            try await Task.sleep(for: .milliseconds(50))
            task.cancel()

            await #expect(throws: CancellationError.self) {
                try await task.value
            }

            #expect(recorder.respondCallCount == 1)
        }
    }

    @Test
    func execute_whenSessionResponds_returnsDescriptionText() async throws {
        if #available(iOS 26.0, *) {
            let recorder = SessionRecorder()
            let client = CharacterDescriptionSessionClient(
                isResponding: { false },
                respond: { prompt in
                    recorder.recordRespond(to: prompt)
                    return CharacterDescription(text: "Rick is a genius scientist")
                }
            )
            let interactor = GetCharacterDescriptionInteractorByAppleIntelligence(
                sessionClient: client,
                isAvailableOverride: true
            )

            let result = try await interactor.execute(character: Character.rick)

            #expect(result == "Rick is a genius scientist")
            #expect(recorder.respondCallCount == 1)
            #expect(recorder.prompts.first?.contains("Rick Sanchez") == true)
        }
    }
}

// MARK: Test doubles

private final class SessionRecorder: @unchecked Sendable {

    private let lock = NSLock()
    private var respondCallCountStorage = 0
    private var promptsStorage: [String] = []

    var respondCallCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return respondCallCountStorage
    }

    var prompts: [String] {
        lock.lock()
        defer { lock.unlock() }
        return promptsStorage
    }

    func recordRespond(to prompt: String) {
        lock.lock()
        defer { lock.unlock() }
        respondCallCountStorage += 1
        promptsStorage.append(prompt)
    }

    func spinUntilCancelled() {
        while !Task.isCancelled {
            Thread.sleep(forTimeInterval: 0.01)
        }
    }
}
