//
//  ForecastResponseMock.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/23.
//

@testable import WeatherData

extension ForecastResponse {

    static func mock() -> ForecastResponse {
        return ForecastResponse(
            cnt: 7,
            cod: "200",
            list: [
                .init(
                    dt: 1772244000,
                    temp: .init(day: 297.82),
                    weather: [
                        .init(main: "Rainy", description: "", icon: "10d")
                    ])
            ])
    }
}
