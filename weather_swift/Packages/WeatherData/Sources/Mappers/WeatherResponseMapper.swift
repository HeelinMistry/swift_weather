//
//  WeatherDTO.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import WeatherCore
import Foundation

extension WeatherResponse {

    func toEntity() -> CurrentWeather {
        let apiCondition = weather.first?.main ?? ""
        let mappedCondition = WeatherCondition(apiString: apiCondition)

        return CurrentWeather(
            name: name,
            currentTemp: main.temp?.formatTemp ?? 0.0,
            maxTemp: main.temp_max?.formatTemp ?? 0.0,
            minTemp: main.temp_min?.formatTemp ?? 0.0,
            condition: mappedCondition
        )
    }
}
