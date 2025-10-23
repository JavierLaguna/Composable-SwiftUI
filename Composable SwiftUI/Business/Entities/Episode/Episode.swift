import UIKit
import JLagunaDevMacros

@Copyable
struct Episode: Equatable, Identifiable, Hashable {
    let id: Int
    let name: String
    let airDate: Date
    let code: String
    let characters: [Int]
    let created: Date
    let image: UIImage?
}
