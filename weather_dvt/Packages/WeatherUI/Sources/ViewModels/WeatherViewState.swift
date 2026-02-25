//
//  WeatherViewState.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import WeatherCore

public enum WeatherViewState: Equatable {
    case idle
    case loading
    case success(WeatherData)
    case error(String)
}
