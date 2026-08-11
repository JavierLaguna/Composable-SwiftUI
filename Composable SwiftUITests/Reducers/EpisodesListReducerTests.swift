import Foundation
import Testing
import ComposableArchitecture
import Mockable
@testable import Composable_SwiftUI

@Suite(
    "EpisodesListReducer",
    .tags(.reducer)
)
struct EpisodesListReducerTests {

    @Test
    func onAppearSuccess() async {
        let mockInteractor = MockGetEpisodesInteractor()
        let mockResponse = [Episode.mock]
        let store = await TestStore(
            initialState: EpisodesListReducer.State(),
            reducer: {
                EpisodesListReducer(getEpisodesInteractor: mockInteractor)
            }
        )

        given(mockInteractor)
            .execute()
            .willReturn(mockResponse)

        await store.send(.onAppear)

        await store.receive(\.getEpisodes) {
            $0.episodes.state = .loading
        }

        await store.receive(\.onReceiveEpisodes.success) {
            $0.episodes.state = .populated(data: mockResponse)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)

        verify(mockInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockInteractor)
            .execute(ids: .any)
            .called(.never)
    }

    @Test
    func getMoreEpisodesSuccessAndAppend() async {
        let mockInteractor = MockGetEpisodesInteractor()
        let initialEpisodes = Episode.mocks
        let newEpisodes = [Episode.mock]
        var initialState = EpisodesListReducer.State()
        initialState.episodes.state = .populated(data: initialEpisodes)

        let store = await TestStore(
            initialState: initialState,
            reducer: {
                EpisodesListReducer(getEpisodesInteractor: mockInteractor)
            }
        )

        given(mockInteractor)
            .execute()
            .willReturn(newEpisodes)

        await store.send(.getMoreEpisodes)

        await store.receive(\.getEpisodes) {
            $0.episodes.state = .loading
        }

        await store.receive(\.onReceiveEpisodes.success) {
            $0.episodes.state = .populated(data: initialEpisodes + newEpisodes)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)

        verify(mockInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockInteractor)
            .execute(ids: .any)
            .called(.never)
    }

    @Test
    func onAppearFail() async {
        let mockInteractor = MockGetEpisodesInteractor()
        let mockError = InteractorError.generic(message: "mock error")
        let store = await TestStore(
            initialState: EpisodesListReducer.State(),
            reducer: {
                EpisodesListReducer(getEpisodesInteractor: mockInteractor)
            }
        )

        given(mockInteractor)
            .execute()
            .willThrow(mockError)

        await store.send(.onAppear)

        await store.receive(\.getEpisodes) {
            $0.episodes.state = .loading
        }

        await store.receive(\.onReceiveEpisodes.failure) {
            $0.episodes.state = .error(mockError)
        }

        verify(mockInteractor)
            .execute()
            .called(.once)

        verify(mockInteractor)
            .execute(id: .any)
            .called(.never)

        verify(mockInteractor)
            .execute(ids: .any)
            .called(.never)
    }
}
