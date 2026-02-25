//
//  FavouriteRepository.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/24.
//

import Foundation
import WeatherCore
import WeatherCommon
public final class FavouriteRepository: FavouriteRepositoryProtocol {
    private let cache: any WeatherCacheService
    private let fileName = "user_favourites"

    public init(cache: any WeatherCacheService) {
        self.cache = cache
    }

    public func getFavourites() async throws -> [FavouriteLocation] {
        let entry: CacheEntry<[FavouriteLocation]>? = await cache.load(fileName: fileName)
        return entry?.data ?? []
    }

    public func saveFavourite(_ location: FavouriteLocation) async throws {
        var current = try await getFavourites()
        // Prevent duplicates
        guard !current.contains(where: { $0.latitude == location.latitude && $0.longitude == location.longitude }) else { return }
        
        current.append(location)
        await cache.save(current, lat: 0, lon: 0, fileName: fileName)
    }

    public func deleteFavourite(_ location: FavouriteLocation) async throws {
        var current = try await getFavourites()
        current.removeAll { $0.id == location.id }
        await cache.save(current, lat: 0, lon: 0, fileName: fileName)
    }
}
