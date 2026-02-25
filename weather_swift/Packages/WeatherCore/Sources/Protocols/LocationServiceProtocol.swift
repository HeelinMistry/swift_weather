//
//  LocationServiceProtocol.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/22.
//

public protocol LocationServiceProtocol: Sendable {
    func getCurrentLocation() async throws -> (lat: Double, lon: Double)
}
