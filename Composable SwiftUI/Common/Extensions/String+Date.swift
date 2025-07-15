import Foundation

extension String {

    /// Returns a `Date` from a `"yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" String`
    func dateFromApiDateString() -> Date? {
        DateFormatterFactory().apiResponseFormatter().date(from: self)
    }

    /// Returns a `Date` from a `"MMMM d, yyyy" String`
    func dateFromApiMonthDayYearDateString() -> Date? {
        DateFormatterFactory().apiMonthDayYearFormatter().date(from: self)
    }
}
