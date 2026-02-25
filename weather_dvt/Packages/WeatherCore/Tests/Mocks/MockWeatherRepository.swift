//
//  MockWeatherRepository.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/21.
//

import WeatherCore

final class MockWeatherRepository: WeatherRepositoryProtocol, @unchecked Sendable {
    var fetchCalled = false
    var lastCoordinates: (lat: Double, lon: Double)?

    var weatherResult: Result<CurrentWeather, Error>?
    var forecastResult: Result<[DayForecast], Error>?

    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather {
        fetchCalled = true
        lastCoordinates = (lat, lon)

        switch weatherResult {
        case .success(let entity):
            return entity
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set before calling execute")
        }
    }

    func fetchWeatherForecast(lat: Double, lon: Double) async throws -> [DayForecast] {
        fetchCalled = true
        lastCoordinates = (lat, lon)

        switch forecastResult {
        case .success(let entity):
            return entity
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set before calling execute")
        }
    }
}
