//
//  Date+Ext.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation

extension Date {
    static var defaultTimeZone: TimeZone {
        TimeZone(identifier: "America/Sao_Paulo") ?? TimeZone.current
    }
    static let defaultLocale = Locale(identifier: "pt_BR")
    static public var locale = Self.defaultLocale
    static public var timeZone = Self.defaultTimeZone

    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: 1, to: date)!

        var arrDates = [String]()

        for _ in 1 ... nDays {
            date = cal.date(byAdding: .day, value: -1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
    
    static func getDatesOfCurrentMonth() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let currentDayString = dateFormatter.string(from: Date())
        let currentDay = Int(currentDayString) ?? 0

        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        date = cal.date(byAdding: .day, value: 1, to: date)!

        var arrDates = [String]()

        for _ in 1 ... currentDay {
            date = cal.date(byAdding: .day, value: -1, to: date)!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }

//    public init?(dateString string: String?, dateFormat: String = "dd/MM/yyyy") {
//        let formatter = DateFormatter()
//        formatter.timeZone = Self.timeZone
//        formatter.locale = Self.locale
//        formatter.dateFormat = dateFormat
//        if let date = formatter.date(from: string ?? "") {
//            self = date
////            self.e
////            encoding = .dateWithoutTimeZone
//        } else {
//            return nil
//        }
//    }

}

final class SimpleDateFormatter {

    private let formatter: DateFormatter

    init(formatter: DateFormatter = .init()) {
        self.formatter = formatter
    }

    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    }

    func getExtendedStringDate(from string: String) -> String? {
        guard let date = makeDate(from: string) else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd 'de' MMMM 'de' yyyy"
        return formatter.string(from: date).capitalized.replacingOccurrences(of: "De", with: "de")
    }

    func getSeparatedDate(from string: String) -> (dayMonth: String, year: String)? {
        guard let date = makeDate(from: string) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        let dayMonth = formatter.string(from: date)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        return (dayMonth: dayMonth, year: year)
    }

    func getFormatedStringDate(from string: String) -> String? {
        guard let date = makeDate(from: string) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    func makeSimpleDate(from string: String) -> Date? {
        formatter.dateFormat = "dd/MM/yyyy"
        return makeDate(from: string)
    }

    func date(from string: String) -> Date? {
        makeDate(from: string)
    }

    func makeDate(from string: String) -> Date? {
        formatter.date(from: string)
    }
}

extension String {
    public func toDate() -> Date? {
        SimpleDateFormatter().makeDate(from: self)
    }
}

public struct STNDate: RawRepresentable {
    public let rawValue: Date

    // MARK: - Configuration

    public var locale = Self.defaultLocale
    public var timeZone = Self.defaultTimeZone

    public var encoding = Encoding.iso8601

    public var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = locale
        calendar.timeZone = timeZone
        return calendar
    }

    private let dateFormatter = DateFormatter()

    // MARK: - Init

    public init(rawValue: Date) {
        self.rawValue = rawValue
    }

    public init?(rawValue: Date?) {
        guard let rawValue = rawValue else { return nil }
        self.rawValue = rawValue
    }

    public init() {
        rawValue = Date()
    }

    public init?(
        day: Int,
        month: Int,
        year: Int,
        hour: Int = 0,
        minute: Int = 0,
        second: Int = 0,
        timeZone: TimeZone? = nil
    ) {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.hour = hour
        components.minute = minute
        components.second = second
        components.timeZone = timeZone ?? Self.defaultTimeZone

        guard let interval = Calendar.current.date(from: components)?.timeIntervalSinceReferenceDate else {
            return nil
        }

        rawValue = Date(timeIntervalSinceReferenceDate: interval)
        self.timeZone = timeZone ?? Self.defaultTimeZone
    }

    /// Create an STNDate ignoring time zone (use default time zone)
    public init?(dateString string: String?, dateFormat: String = "dd/MM/yyyy") {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.dateFormat = dateFormat
        if let date = formatter.date(from: string ?? "") {
            rawValue = date
            encoding = .dateWithoutTimeZone
        } else {
            return nil
        }
    }

}

// MARK: - STNDate toString

extension STNDate {
    public func string(dateStyle: Style = .none, timeStyle: Style = .none) -> String {
        let date = dateString(style: dateStyle)
        let time = timeString(style: timeStyle)

        switch (dateStyle, timeStyle) {
        case (.none, .none): return ""
        case (_, .none): return date
        case (_, .truncated): return date
        case (.none, _): return time
        default: return [date, time].joined(separator: " às ")
        }
    }

    private func dateString(style: Style) -> String {
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = style.dateFormat

        if case .custom = style {
            return dateFormatter.string(from: rawValue)
        }
        // iOS 15+ changed the locale .br formatter to add a dot to the end of abbreviated months
        // this change fix it.
        return dateFormatter.string(from: rawValue).replacingOccurrences(of: ".", with: "")
    }

    private func timeString(style: Style) -> String {
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = style.timeFormat
        return dateFormatter.string(from: rawValue)
    }
}

// MARK: - CustomDebugStringConvertible

extension STNDate: CustomDebugStringConvertible {
    public var debugDescription: String { string(dateStyle: .short, timeStyle: .short) }
}

// MARK: - Classes

public extension STNDate {
    enum DateError: Error, Equatable, LocalizedError {
        case unknownDateFormat(date: String)
        case invalidDate(date: String)

        public var errorDescription: String? {
            switch self {
            case .unknownDateFormat(let date): return "Unknown date format: \(date)"
            case .invalidDate(let date): return "Invalid date: \(date)"
            }
        }
    }

    enum Style {
        /// dd 'de' MMMM, yyyy
        case long
        /// dd 'de' MMMM 'de' yyyy
        case veryLong
        /// dd MMMM, yyyy
        case medium
        /// dd/MM/yyyy
        case short
        /// MM/yyyy
        case truncated
        /// MMM/yy
        case small
        case none
        /// dd MMM, yyyy
        case semiLong
        case custom(String)

        internal var dateFormat: String {
            switch self {
            case .long: return "dd 'de' MMMM, yyyy"
            case .veryLong: return "dd 'de' MMMM 'de' yyyy"
            case .medium: return "dd MMMM, yyyy"
            case .short: return "dd/MM/yyyy"
            case .small: return "MMM/yy"
            case .truncated: return "MM/yyyy"
            case .semiLong: return "dd MMM, yyyy"
            case .custom(let style): return style
            case .none: return ""
            }
        }

        internal var timeFormat: String {
            switch self {
            case .long: return "HH:mm:ss"
            case .medium: return "HH'h'mm"
            case .short: return "HH:mm"
            case .small: return "HH'h'"
            case .custom(let style): return style
            case .none, .truncated, .semiLong, .veryLong: return ""
            }
        }
    }

    enum Encoding {
        case iso8601
        case dateWithoutTimeZone
    }
}

public extension STNDate {
    static let defaultLocale = Locale(identifier: "pt_BR")

    static var defaultTimeZone: TimeZone {
        TimeZone(identifier: "America/Sao_Paulo") ?? TimeZone.current
    }

    static var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = defaultLocale
        calendar.timeZone = defaultTimeZone
        return calendar
    }

    static var utcCalendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Self.defaultLocale
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar
    }

    static var now: STNDate {
        .today
    }

    static var distantPast: STNDate {
        STNDate(rawValue: Date.distantPast)
    }

    static var distantFuture: STNDate {
        STNDate(rawValue: Date.distantFuture)
    }

    static var today: STNDate {
        calendar.startOfDay(for: STNDate.now.rawValue).stn
    }

    static var yesterday: STNDate {
        STNDate.today.adding(component: .day, value: -1)
    }

    static var tomorrow: STNDate {
        STNDate.today.adding(component: .day, value: 1)
    }

    static var oneYearFromNow: STNDate {
        today.adding(component: .year, value: 1)
    }

    static var oneYearAgo: STNDate {
        today.adding(component: .year, value: -1)
    }

    static var twoYearsAgo: STNDate {
        today.adding(component: .year, value: -2)
    }

    static var threeMonthsAgo: STNDate {
        today
            .adding(component: .month, value: -3)
            .adding(component: .day, value: 1)
    }

}

// MARK: - Helpers

public extension STNDate {

    /// Returns a new `STNStaticDate` representation of this instance
    var staticDate: STNStaticDate {
        STNStaticDate(date: self)
    }

    /// Returns a new STNDate representing the start of the month
    /// (first day of the month; will have time set to 0:00 UTC+03:00)
    var startOfMonth: STNDate {
        STNDate(day: 1, month: month, year: year) ?? self
    }

    /// Returns a new STNDate representing the end of the month
    /// (last day of the month; will have time set to 0:00 UTC+03:00)
    var endOfMonth: STNDate {
        startOfMonth
            .adding(component: .month, value: 1)
            .adding(component: .day, value: -1)
    }

    /// Returns a new STNDate representing the start of the day
    /// (will have time set to 0:00 UTC+03:00)
    var startOfDay: STNDate {
        calendar.startOfDay(for: rawValue).stn
    }

    /// Returns a new STNDate representing the end of the day
    /// (will have time set to 23:59 UTC+03:00)
    var endOfDay: STNDate {
        STNDate(day: day, month: month, year: year, hour: 23, minute: 59, second: 59, timeZone: timeZone) ?? .now
    }

    /// Returns a new STNDate representing the start of the year
    /// (will have time set to 0:00 UTC+03:00)
    var startOfYear: STNDate {
        STNDate(day: 1, month: 1, year: year) ?? self
    }

    /// Returns a new STNDate representing the start of the year
    /// (will have time set to 23:59 UTC+03:00)
    var endOfYear: STNDate {
        STNDate(day: 1, month: 12, year: year)?.endOfMonth.endOfDay ?? self
    }

    // MARK: - Syntax Sugar

    var year: Int { calendar.component(.year, from: rawValue) }
    var month: Int { calendar.component(.month, from: rawValue) }
    var day: Int { calendar.component(.day, from: rawValue) }
    var hour: Int { calendar.component(.hour, from: rawValue) }
    var minute: Int { calendar.component(.minute, from: rawValue) }
    var second: Int { calendar.component(.second, from: rawValue) }
    var weekday: Int { calendar.component(.weekday, from: rawValue) }

    /// Returns a new `STNDate` representing the date calculated by adding an amount of a specific component to a given date.
    ///
    /// - parameter component: A single component to add.
    /// - parameter value: The value of the specified component to add.
    /// - returns: A new date, or `.distantPast` if a date could not be calculated with the given input.
    func adding(component: Calendar.Component, value: Int) -> STNDate {
        guard let date = calendar.date(byAdding: component, value: value, to: rawValue) else {
            return value > 0 ? STNDate.distantFuture : STNDate.distantPast
        }

        return date.stn
    }

    /// Returns `true` if the date is **greater** than today.
    var isFutureDate: Bool { self > .today }

    /// Returns `true` if the date is **greater** than or **equal** to today.
    var isTodayOrFutureDate: Bool { self >= .today }

    /// Returns `true` if the date is **less** than today.
    var isPastDate: Bool { self < .today }

    /// Returns `true` if the date is **less** than or **equal** to today.
    var isTodayOrPastDate: Bool { self <= .today }
}

// MARK: - Week days
public extension STNDate {

    /// Returns the next valid weekday, including today.
    func nextValidWeekday(daysAhead: Int = 0) -> STNDate {
        if !isWeekend {
            guard daysAhead != 0 else {
                return self
            }
            return adding(component: .day, value: 1).nextValidWeekday(daysAhead: daysAhead - 1)
        } else {
            return adding(component: .day, value: 1).nextValidWeekday(daysAhead: daysAhead)
        }
    }

    /// Returns the previous valid weekday, including today.
    func previousValidWeekday(daysBefore: Int = 0) -> STNDate {
        if !isWeekend {
            guard daysBefore != 0 else {
                return self
            }
            return adding(component: .day, value: -1).previousValidWeekday(daysBefore: daysBefore - 1)
        } else {
            return adding(component: .day, value: -1).previousValidWeekday(daysBefore: daysBefore)
        }
    }

    /// Returns the weekday in string
    /// - Parameter captalized: Used to define whether the first letter of the day will be capitalized. Default is `true`
    /// - Returns: Returns the weekday in string
    func weekdayDescription(captalized: Bool = true) -> String {
        let description = calendar.weekdaySymbols[weekday - 1]
        return captalized ? description.capitalized : description
    }
}

public extension Date {
    var stn: STNDate { STNDate(rawValue: self) }

    /// Algumas APIs retornam a data com o timezone em UTC
    /// Essa property converte um Date no timezone 0 (UTC)
    /// e utiliza o mesmo `day`, `month` e `year` para criar uma data com o timezone default do `STNDate`
    ///
    /// Ex:
    /// ```swift
    /// let date = Date() // 01/02/2021 00:00:00 000Z
    /// date.stnIgnoringTimezone // 01/02/2021 00:00:00 200Z
    /// ```
    var stnIgnoringTimezone: STNDate? {
        let calendar = STNDate.utcCalendar
        return STNDate(
            day: calendar.component(.day, from: self),
            month: calendar.component(.month, from: self),
            year: calendar.component(.year, from: self)
        )
    }
}

public struct STNStaticDate: Codable, Equatable, Hashable {

    public static var now: STNStaticDate { .init() }

    public let day: Int
    public let month: Int
    public let year: Int

    public var stnDate: STNDate {
        STNDate(day: day, month: month, year: year) ?? .distantPast
    }

    private var components: DateComponents {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.calendar = STNDate.calendar
        return components
    }

    private var isValid: Bool { components.isValidDate }

    /// Returns a new `STNStaticDate` representing the start of the month
    public var startOfMonth: STNStaticDate {
        stnDate.startOfMonth.staticDate
    }

    /// Returns a new `STNSaticDate` representing the end of the month
    public var endOfMonth: STNStaticDate {
        stnDate.endOfMonth.staticDate
    }

    public init(day: Int, month: Int, year: Int) throws {
        self.day = day
        self.month = month
        self.year = year

        if isValid.not {
            throw STNDate.DateError.invalidDate(date: "\(year)-\(month)-\(day)")
        }
    }

    public init() {
        let now = STNDate.now
        day = now.day
        month = now.month
        year = now.year
    }

    public init(date: STNDate) {
        day = date.day
        month = date.month
        year = date.year
    }

    public init(from decoder: Decoder) throws {
        let date = try STNDate(from: decoder)
        day = date.day
        month = date.month
        year = date.year

        if isValid.not {
            throw STNDate.DateError.invalidDate(date: "\(year)-\(month)-\(day)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        if isValid.not {
            throw STNDate.DateError.invalidDate(date: "\(year)-\(month)-\(day)")
        }

        guard var date = STNDate(day: day, month: month, year: year) else {
            throw STNDate.DateError.invalidDate(date: "\(year)-\(month)-\(day)")
        }

        date.encoding = .dateWithoutTimeZone
        try date.encode(to: encoder)
    }

    // MARK: - Helpers

    public func string(style: STNDate.Style) -> String {
        stnDate.string(dateStyle: style, timeStyle: .none)
    }

    /// Returns a new `STNStaticDate` representing the date calculated by adding an amount of a specific component to a given date.
    ///
    /// - parameter component: A single component to add.
    /// - parameter value: The value of the specified component to add.
    /// - returns: A new date, or `.distantPast` if a date could not be calculated with the given input.
    public func adding(component: Calendar.Component, value: Int) -> STNStaticDate {
        stnDate.adding(component: component, value: value).staticDate
    }
}

// MARK: - Comparable
extension STNStaticDate: Comparable {
    public static func < (lhs: STNStaticDate, rhs: STNStaticDate) -> Bool {
        lhs.stnDate < rhs.stnDate
    }

    public static func <= (lhs: STNStaticDate, rhs: STNStaticDate) -> Bool {
        lhs.stnDate <= rhs.stnDate
    }

    public static func >= (lhs: STNStaticDate, rhs: STNStaticDate) -> Bool {
        lhs.stnDate >= rhs.stnDate
    }

    public static func > (lhs: STNStaticDate, rhs: STNStaticDate) -> Bool {
        lhs.stnDate > rhs.stnDate
    }
}

extension STNDate: Equatable, Comparable {

    public var isBeforeThreeMonthsAgo: Bool {
        let result = calendar.compare(
            rawValue,
            to: STNDate.threeMonthsAgo.rawValue,
            toGranularity: .year
        )
        return result == .orderedAscending
    }

    public func isSameDayMonthYear(as otherDate: STNDate, calendar: Calendar = STNDate.calendar) -> Bool {
        calendar.isDate(rawValue, inSameDayAs: otherDate.rawValue)
    }

    public var isToday: Bool { isToday() }
    public var isWeekend: Bool { calendar.isDateInWeekend(rawValue) }

    /// Check if self is in today
    /// - Parameter calendar: Calendar to test if is today
    /// - Returns: Boolean indicating if this date is today
    public func isToday(calendar: Calendar = STNDate.calendar) -> Bool {
        calendar.startOfDay(for: rawValue).stn == .today
    }

    public static func == (lhs: STNDate, rhs: STNDate) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    public static func < (lhs: STNDate, rhs: STNDate) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension STNDate: Hashable {}

extension STNDate: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        do {
            rawValue = try Self.decode(string: string).rawValue
        } catch {
            let context = DecodingError.Context(
                codingPath: container.codingPath,
                debugDescription: error.localizedDescription,
                underlyingError: error
            )
            throw DecodingError.typeMismatch(STNDate.self, context)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch encoding {
        case .iso8601:
            try container.encode(Self.ISO8601Formatter.string(from: rawValue))

        case .dateWithoutTimeZone:
            try container.encode(Self.nonISO8601Formatter.string(from: rawValue))
        }
    }

    public static func decode(string: String) throws -> STNDate {
        if let date = Self.ISO8601Formatter.date(from: string) {
            return date.stn
        } else if let date = Self.ISO8601MilisecondsFormatter.date(from: string) {
            return date.stn
        } else if let date = Self.nonISO8601Formatter.date(from: string) {
            return date.stn
        } else if let date = Self.withMillisecondsFormatter.date(from: string) {
            return date.stn
        } else if let date = Self.ISO8601Formatter.date(from: "\(string)Z") {
            return date.stn
        } else {
            throw DateError.unknownDateFormat(date: string)
        }
    }
}

// MARK: - Private Helpers

private extension STNDate {
    static let ISO8601Formatter = ISO8601DateFormatter()

    static let ISO8601MilisecondsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = Self.defaultTimeZone
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    static let withMillisecondsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = Self.defaultTimeZone
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter
    }()

    static let nonISO8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = Self.defaultTimeZone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
