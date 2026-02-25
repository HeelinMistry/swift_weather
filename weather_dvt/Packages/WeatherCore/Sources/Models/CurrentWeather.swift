//
//  Weather.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation

public struct CurrentWeather: Sendable, Equatable, Encodable {
    public let name: String
    public let currentTemp: Double
    public let maxTemp: Double
    public let minTemp: Double
    public let condition: WeatherCondition

    public init(name: String, currentTemp: Double, maxTemp: Double, minTemp: Double, condition: WeatherCondition) {
        self.name = name
        self.currentTemp = currentTemp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.condition = condition
    }
}
