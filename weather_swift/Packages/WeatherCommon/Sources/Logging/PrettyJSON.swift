//
//  PrettyJSON.swift
//  WeatherCommon
//
//  Created by Heelin Mistry on 2026/02/21.
//

import Foundation

enum PrettyJSON {
    /// An internal method used to make response more easily readable
    public static func stringify<T: Encodable>(
        _ value: T,
        dateStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
    ) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = dateStrategy
        do {
            let data = try encoder.encode(value)
            guard let json = String(bytes: data, encoding: .utf8) else {
                return "JSON Decode Failed (Invalid UTF-8)"
            }
            return json
        } catch {
            return "JSON Encode Failed: \(error)"
        }
    }
}
