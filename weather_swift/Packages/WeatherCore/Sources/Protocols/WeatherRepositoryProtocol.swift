//
//  WeatherRepositoryProtocol.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/20.
//

/// A protocol defining the contract for weather data retrieval.
///
/// The implementation should handle the orchestration between local persistence
/// and remote API calls.
public protocol WeatherRepositoryProtocol: Sendable {

    /// Fetches the current weather forecast for a specific coordinate.
    ///
    /// - Parameters:
    ///   - lat: The latitude of the desired location.
    ///   - lon: The longitude of the desired location.
    /// - Returns: A `CurrentWeather` containing current and daily forecast data.
    /// - Throws: `NetworkError` if the API call fails or `DatabaseError` if caching fails.
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather

    /// Fetches the 5-day forecast for a specific coordinate.
    ///
    /// - Parameters:
    ///   - lat: The latitude of the desired location.
    ///   - lon: The longitude of the desired location.
    /// - Returns: A `[DayForecast]` containing current and daily forecast data.
    /// - Throws: `NetworkError` if the API call fails or `DatabaseError` if caching fails.
    func fetchWeatherForecast(lat: Double, lon: Double) async throws -> [DayForecast]
}
