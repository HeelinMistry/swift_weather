//
//  CurrentWeatherTemperatureView.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/22.
//

import SwiftUI
import WeatherCore

struct CurrentWeatherTemperatureView: View {
    let weather: CurrentWeather
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(spacing: 0) {
                    Text(weather.minTemp.displayTemp)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("min")
                        .font(.system(size: 18, weight: .thin))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                Spacer()
                VStack(spacing: 0) {
                    Text(weather.minTemp.displayTemp)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("current")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                Spacer()
                VStack(spacing: 0) {
                    Text(weather.minTemp.displayTemp)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("max")
                        .font(.system(size: 18, weight: .thin))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
