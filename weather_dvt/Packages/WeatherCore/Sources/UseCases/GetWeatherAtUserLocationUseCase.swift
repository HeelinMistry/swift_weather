//
//  FetchWeatherAtCurrentLocationUseCase.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/22.
//

import Foundation
import WeatherCommon

public protocol GetWeatherAtUserLocationUseCaseProtocol: Sendable {
    func execute(_ location: Coord?) async throws -> (Coord, CurrentWeather, [DayForecast])
}

public final class GetWeatherAtUserLocationUseCase: GetWeatherAtUserLocationUseCaseProtocol {
    private let location: any LocationServiceProtocol
    private let weather: any WeatherRepositoryProtocol

    public init(
        location: any LocationServiceProtocol,
        weather: any WeatherRepositoryProtocol
    ) {
        self.location = location
        self.weather = weather
    }

    public func execute(_ givenCoord: Coord? = nil) async throws -> (Coord, CurrentWeather, [DayForecast]) {
        var coord: (lat: Double, lon: Double)
        if let givenCoord {
            coord = (givenCoord.lat, givenCoord.lon)
        } else {
            coord = try await location.getCurrentLocation()
        }
        do {
            let currentWeather = try await weather.fetchCurrentWeather(lat: coord.lat, lon: coord.lon)
            Log.networking.json("Successfully fetched weather", currentWeather)

            let weatherForecast = try await weather.fetchWeatherForecast(lat: coord.lat, lon: coord.lon)
            Log.networking.json("Successfully fetched forecast", weatherForecast)

            let coordinates: Coord = .init(lon: coord.lon, lat: coord.lat)
            return (coordinates, currentWeather, weatherForecast)
        } catch {
            throw error
        }
    }
}
