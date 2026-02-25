//
//  CurrentWeatherView.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import SwiftUI
import WeatherCore

struct CurrentWeatherView: View {
    let weather: CurrentWeather
    
    var body: some View {
        VStack(spacing: 8) {
            Text(weather.currentTemp.displayTemp)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 60)
            Text(weather.condition.rawValue.uppercased())
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 40)
    }
}
