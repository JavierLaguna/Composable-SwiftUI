import Foundation

extension String {

    func getIdFromUrl() -> Int? {
        guard let idString = URL(string: self)?.lastPathComponent else {
            return nil
        }

        return Int(idString)
    }
}
