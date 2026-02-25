//
//  CacheEntry.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation

public struct CacheEntry<T: Codable & Sendable>: Codable, Sendable {
    public let data: T
    public let timestamp: Date
    public let lat: Double
    public let lon: Double

    public var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > 1800
    }
}
