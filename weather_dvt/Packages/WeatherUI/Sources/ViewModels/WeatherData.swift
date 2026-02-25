//
//  WeatherData.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/23.
//

import Foundation
import WeatherCore

public struct WeatherData: Sendable, Equatable, Encodable {
    public let coord: Coord
    public let currentWeather: CurrentWeather
    public let forecast: [DayForecast]

    public init(coord: Coord, currentWeather: CurrentWeather, forecast: [DayForecast]) {
        self.coord = coord
        self.currentWeather = currentWeather
        self.forecast = forecast
    }
}
