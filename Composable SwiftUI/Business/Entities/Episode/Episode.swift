import Foundation
import UIKit

struct Episode: Equatable, Identifiable {
    let id: Int
    let name: String
    let airDate: Date
    let episode: String
    let characters: [Int]
    let created: Date
    let image: UIImage?
}
