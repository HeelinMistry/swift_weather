//
//  MockLocationService.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/23.
//

import WeatherCore

final class MockLocationService: LocationServiceProtocol, @unchecked Sendable {
    var fetchCalled = false
    var lastCoordinates: (lat: Double, lon: Double)?
    
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
