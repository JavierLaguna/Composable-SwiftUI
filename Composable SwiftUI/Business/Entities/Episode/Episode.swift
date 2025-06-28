import Foundation
import UIKit

struct Episode: Equatable, Identifiable, Hashable {
    let id: Int
    let name: String
    let airDate: Date
    let code: String
    let characters: [Int]
    let created: Date
    let image: UIImage?
}
