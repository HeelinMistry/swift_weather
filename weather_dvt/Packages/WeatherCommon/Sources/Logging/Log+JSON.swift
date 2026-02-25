//
//  Log+JSON.swift
//  WeatherCommon
//
//  Created by Heelin Mistry on 2026/02/21.
//

import Foundation
import OSLog

public extension Logger {
    /// Logs an `Encodable` value as a pretty-printed JSON string.
    ///
    /// - Parameters:
    ///   - label: An optional label to precede the JSON output.
    ///   - value: The `Encodable` value to be serialized and logged.
    ///   - level: The `OSLogType` for the log message. Defaults to `.debug`.
    func json<T: Encodable>(
        _ label: String = "",
        _ value: T,
        level: OSLogType = .debug
    ) {
        let json = PrettyJSON.stringify(value)
        if label.isEmpty {
            log(level: level, "\(json, privacy: .public)")
        } else {
            log(level: level, "\(label, privacy: .public):\n\(json, privacy: .public)")
        }
    }
}
