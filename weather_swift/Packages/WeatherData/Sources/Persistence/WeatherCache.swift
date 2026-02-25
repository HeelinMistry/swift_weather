//
//  WeatherDiskCache.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation
import WeatherCommon
import OSLog

public protocol WeatherCacheService: Sendable {
    func save<T: Codable & Sendable>(_ item: T, lat: Double, lon: Double, fileName: String) async
    func load<T: Codable>(fileName: String) async -> CacheEntry<T>?
    func clearCache() async
}

public actor WeatherDiskCache: WeatherCacheService {
    private let fileManager = FileManager.default
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var cacheFolder: URL {
//        CachesDirectory - it respects iOS storage management (the OS can purge it if the phone is full) and handles file I/O off the main thread.
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    public init() {}

    public func save<T: Codable & Sendable>(_ item: T, lat: Double, lon: Double, fileName: String) async {
        let entry = CacheEntry(data: item, timestamp: Date(), lat: lat, lon: lon)
        let url = cacheFolder.appendingPathComponent("\(fileName).json")
        
        do {
            let data = try encoder.encode(entry)
            try data.write(to: url, options: .atomic)
            Log.persistence.info("Cached \(fileName) successfully.")
        } catch {
            Log.persistence.error("Failed to cache \(fileName): \(error.localizedDescription)")
        }
    }

    public func load<T: Codable>(fileName: String) async -> CacheEntry<T>? {
        let url = cacheFolder.appendingPathComponent("\(fileName).json")
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            Log.persistence.json("Cached Object", data)
            return try decoder.decode(CacheEntry<T>.self, from: data)
        } catch {
            Log.persistence.error("Failed to load cache \(fileName): \(error.localizedDescription)")
            return nil
        }
    }
    
    public func clearCache() async {
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheFolder, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
            Log.persistence.info("Cache cleared successfully.")
        } catch {
            Log.persistence.error("Failed to clear cache: \(error.localizedDescription)")
        }
    }
}
