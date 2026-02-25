//
//  MockFavouriteRepository.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/24.
//

import WeatherCore
import Foundation

final class MockFavouriteRepository: FavouriteRepositoryProtocol, @unchecked Sendable {
    var result: Result<[FavouriteLocation], Error>?
    var delay: UInt64 = 0
    
    func getFavourites() async throws -> [FavouriteLocation] {
        try await Task.sleep(nanoseconds: delay)
        switch result {
        case .success(let entity):
            return entity
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set")
        }
    }
    
    func saveFavourite(_ location: FavouriteLocation) async throws {
        try await Task.sleep(nanoseconds: delay)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set")
        }
    }
    
    func deleteFavourite(_ location: WeatherCore.FavouriteLocation) async throws {
        try await Task.sleep(nanoseconds: delay)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set")
        }
    }
}
