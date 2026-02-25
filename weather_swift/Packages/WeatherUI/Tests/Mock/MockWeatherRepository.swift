//
//  MockWeatherRepository.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import WeatherCore
import Foundation

final class MockWeatherRepository: WeatherRepositoryProtocol, @unchecked Sendable {

    var weatherResult: Result<CurrentWeather, Error>?
    var forecastResult: Result<[DayForecast], Error>?
    var delay: UInt64 = 0

    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather {
        try await Task.sleep(nanoseconds: delay)
        switch weatherResult {
        case .success(let entity):
            return entity
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set")
        }
    }

    func fetchWeatherForecast(lat: Double, lon: Double) async throws -> [DayForecast] {
        try await Task.sleep(nanoseconds: delay)
        switch forecastResult {
        case .success(let entity):
            return entity
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set")
        }
    }
}
