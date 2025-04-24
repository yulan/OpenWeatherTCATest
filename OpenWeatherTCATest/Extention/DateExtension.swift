//
//  DateExtension.swift
//  WeatherTCAApp
//
//  Created by Lan YU on 22/04/2025.
//

import Foundation

extension Date {
    /// Convert a Unix timestamp to a `Date` object.
    /// - Parameter timestamp: The Unix timestamp (in seconds).
    public static func fromUnixTimestamp(_ timestampInt: Int32?) -> Date? {
        guard let timestampInt = timestampInt else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(timestampInt))
    }
    
    /// Format the date as a 24-hour time string (e.g., "HH:mm").
    /// - Parameter timeZone: The desired timezone for formatting.
    ///   Defaults to the current system timezone.
    public func to24HourTimeString(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour time format
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}
