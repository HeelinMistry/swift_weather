//
//  MockFetchCurrentWeatherUseCase.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import WeatherCore
import Foundation

final class MockFetchCurrentWeatherUseCase: GetWeatherAtUserLocationUseCaseProtocol, @unchecked Sendable {

    var result: Result<(Coord, CurrentWeather, [DayForecast]), Error>?
    var executeCalled = false

    func execute(_ location: Coord? = nil) async throws -> (Coord, CurrentWeather, [DayForecast]) {
        executeCalled = true
        switch result {
        case .success((let coord, let weather, let forecasts)):
            return (coord, weather, forecasts)
        case .failure(let error):
            throw error
        case .none:
            fatalError("Mock result not set")
        }
    }
}
