//
//  CurrentWeatherView.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import SwiftUI
import WeatherCore

struct CurrentWeatherHeaderView: View {
    let weather: CurrentWeather
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(weather.condition.backgroundName)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .top)
            VStack {
                VStack(spacing: 8) {
                    Text(weather.currentTemp.displayTemp)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                    Text(weather.condition.rawValue.uppercased())
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                .foregroundColor(.white)
                .padding(.top, 100)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
