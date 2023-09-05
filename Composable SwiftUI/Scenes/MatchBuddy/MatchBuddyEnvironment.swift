import Foundation
import ComposableArchitecture
import Resolver

struct MatchBuddyEnvironment {
    @Injected(name: "main") var mainQueue: AnySchedulerOf<DispatchQueue>
    @Injected var getBeerBuddyInteractor: GetBeerBuddyInteractor
}
