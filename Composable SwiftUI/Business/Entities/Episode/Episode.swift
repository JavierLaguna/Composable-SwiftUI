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

    func withImage(_ image: UIImage?) -> Episode {
        Episode(
            id: id,
            name: name,
            airDate: airDate,
            code: code,
            characters: characters,
            created: created,
            image: image
        )
    }
}
