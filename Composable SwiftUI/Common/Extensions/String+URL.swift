extension String {

    func getIdFromUrl() -> Int? {
        guard let lastIndex = self.lastIndex(of: "/") else {
            return nil
        }

        return Int(self[self.index(after: lastIndex)...])
    }
}
