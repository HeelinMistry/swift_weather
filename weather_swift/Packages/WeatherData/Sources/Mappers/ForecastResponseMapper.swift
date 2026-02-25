//
//  ForecastResponseMapper.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/22.
//

import WeatherCore
import Foundation

extension ForecastResponse {
    
    func toEntity() -> [DayForecast] {
        var forecasts: [DayForecast] = []
        for day in list ?? [] {
            let iconCondition = day.weather?.first?.icon ?? ""
            let mappedCondition = WeatherCondition(iconString: iconCondition)
            forecasts.append(.init(
                dt: day.dt ?? 0,
                icon: mappedCondition,
                temp: day.temp?.day?.formatTemp ?? 0.0,
            ))
        }
        return forecasts
    }
}
