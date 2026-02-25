//
//  WeatherResponseDTOMock.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/21.
//

@testable import WeatherData

extension WeatherResponse {

    static func mock() -> WeatherResponse {
        return WeatherResponse(
            weather: [.init(main: "Clear", description: "clear sky", icon: "10d")],
            main: .init(
                temp: 298.48,
                feels_like: 298.74,
                temp_min: 297.57,
                temp_max: 300.05
            ),
            dt: 1600000000,
            name: "Zorg",
        )
    }
}
