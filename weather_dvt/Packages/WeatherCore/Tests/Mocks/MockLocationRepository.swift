//
//  MockLocationRepository.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/22.
//

import WeatherCore

final class MockLocationRepository: LocationServiceProtocol, @unchecked Sendable {
    var fetchCalled = false
    
    var result: Result<(lat: Double, lon: Double), Error>?

    func getCurrentLocation() async throws -> (lat: Double, lon: Double) {
        fetchCalled = true
        switch result {
        case .success(let entity):
            return entity
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set before calling execute")
        }
    }
}
