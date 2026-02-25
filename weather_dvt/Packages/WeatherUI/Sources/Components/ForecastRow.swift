//
//  ForecastRow.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import SwiftUI
import WeatherCore

struct ForecastRow: View {
    let forecast: DayForecast
    
    var body: some View {
        HStack {
            Text(forecast.dt.toDayName())
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Image(forecast.icon.weatherIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Text(forecast.temp.displayTemp)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
        }
    }
}
