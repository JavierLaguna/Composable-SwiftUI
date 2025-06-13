import Foundation

struct CharacterDescriptionMock {

    static let description: String = {
        let paragraph = """
           Rick Sanchez is a genius scientist whose alcoholism and reckless, nihilistic behavior are sources of concern for his daughter's family, as well as the safety of their son, Morty. He is easily bored and does not do well with mundane requests, which he often reflects in his creation of some sort of sci-fi gadget to fulfill those requests. Rick shows a disregard for attachment, as he is willing to abandon realities and even family members.


           """

        let repeatCount = Int.random(in: 1...4)
        return repeatElement(paragraph, count: repeatCount).joined()
    }()
}
