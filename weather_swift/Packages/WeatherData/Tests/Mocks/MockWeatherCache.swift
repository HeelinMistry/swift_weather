//
//  MockWeatherCache.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/24.
//
import XCTest
@testable import WeatherData
@testable import WeatherCore

/// A simple mock to simulate WeatherCacheService behavior in memory
actor MockWeatherCache: WeatherCacheService {
    private var storage: [String: Any] = [:]

    func save<T>(_ data: T, lat: Double, lon: Double, fileName: String) async where T: Codable, T: Sendable { 
        // Wrap in CacheEntry to match the repository's loading logic
        let entry = CacheEntry(data: data, timestamp: Date(), lat: 0.0, lon: 0.0)
        storage[fileName] = entry
    }

    func load<T>(fileName: String) async -> CacheEntry<T>? where T: Decodable {
        return storage[fileName] as? CacheEntry<T>
    }

    func clearCache() async {
        storage.removeAll()
    }
}
