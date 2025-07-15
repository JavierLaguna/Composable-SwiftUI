import Foundation

extension String {

    /// Returns a `Date` from a `"yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX" String`
    func dateFromApiFullDateString() -> Date? {
        DateFormatterFactory().apiFullDateFormatter().date(from: self)
    }

    /// Returns a `Date` from a `"MMMM d, yyyy" String`
    func dateFromApiMonthDayYearDateString() -> Date? {
        DateFormatterFactory().apiMonthDayYearDateFormatter().date(from: self)
    }
}
