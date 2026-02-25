//
//  WeatherDashboard.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import SwiftUI
import WeatherCore

public struct WeatherDashboard: View {
    let weather: WeatherData

    public init(weather: WeatherData) {
        self.weather = weather
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CurrentWeatherHeaderView(weather: weather.currentWeather)
            CurrentWeatherTemperatureView(weather: weather.currentWeather)
                .padding(.vertical, 3)
            Rectangle()
                .fill(.white)
                .frame(height: 1)
            ScrollView {
                ForecastListView(forecast: weather.forecast)
                    .padding(.vertical)
            }
        }
        .background(weather.currentWeather.condition.backgroundColour)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    let mockWeather = CurrentWeather(
        name: "Melbourne",
        currentTemp: 21.0,
        maxTemp: 24.0,
        minTemp: 18.0,
        condition: .sunny
    )
    let mockForecast = [DayForecast(dt: 1772164800, icon: .clouds, temp: 19)]
    let mockCoord = Coord(lon: 0.0, lat: 0.0)
    WeatherDashboard(weather: WeatherData(coord: mockCoord, currentWeather: mockWeather, forecast: mockForecast))
}
