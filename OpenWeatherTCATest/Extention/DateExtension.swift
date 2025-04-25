//
//  DateExtension.swift
//  WeatherTCAApp
//
//  Created by Lan YU on 22/04/2025.
//

import Foundation

extension Date {
    /// Converts a Unix timestamp (in seconds) to a `Date` object.
    ///
    /// This method helps convert an integer-based Unix timestamp—commonly used in
    /// APIs or databases—into a native `Date` object in Swift. Useful when parsing
    /// `Int` values like `1650280800` (seconds since 1970-01-01 UTC).
    ///
    /// - Parameter timestampInt: The Unix timestamp as an optional `Int32` value,
    ///   representing the number of seconds since January 1, 1970 (Unix epoch).
    ///
    /// - Returns: A `Date` object if the input is non-nil; otherwise, `nil`.
    public static func fromUnixTimestamp(_ timestampInt: Int32?) -> Date? {
        guard let timestampInt = timestampInt else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(timestampInt))
    }
    
    /// Formats the `Date` as a 24-hour time string (e.g., `"14:30"`).
    ///
    /// This method is useful when you want to display the time portion of a `Date`
    /// in 24-hour format, such as on clocks, timestamps, or schedule UIs.
    ///
    /// - Parameter timeZone: The `TimeZone` to apply during formatting.
    ///   Defaults to the current system time zone (`TimeZone.current`).
    ///
    /// - Returns: A string representing the time in `"HH:mm"` format.
    public func to24HourTimeString(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
    
    /// Formats the `Date` as a calendar date string (e.g., `"2025-04-25"`).
    ///
    /// This method returns the date portion of a `Date` in `"yyyy-MM-dd"` format,
    /// which is commonly used for logs, labels, API requests, or sorting.
    ///
    /// - Parameter timeZone: The `TimeZone` to apply during formatting.
    ///   Defaults to the current system time zone.
    ///
    /// - Returns: A string representing the date in `"yyyy-MM-dd"` format.
    public func toDateString(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}
