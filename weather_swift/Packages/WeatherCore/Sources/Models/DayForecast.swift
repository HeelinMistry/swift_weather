//
//  DayForecast.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation

public struct DayForecast: Sendable, Equatable, Encodable { 
    public let dt: Int
    public let icon: WeatherCondition
    public let temp: Double
    
    public init(dt: Int, icon: WeatherCondition, temp: Double) {
        self.dt = dt
        self.icon = icon
        self.temp = temp
    }
}
