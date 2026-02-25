//
//  weather_dvtApp.swift
//  weather_dvt
//
//  Created by Heelin Mistry on 2026/02/18.
//

import SwiftUI
import WeatherData
import WeatherCore
import WeatherUI

@main
struct WeatherSwiftApp: App {
    let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            WeatherHomeView(
                viewModel: WeatherViewModel(
                    fetchCurrentWeatherUseCase: container.fetchCurrentWeatherUseCase,
                    favouriteRepo: container.favouritesRepository
                )
            )
        }
    }
}
