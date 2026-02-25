//
//  ForecastListView.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/22.
//

import SwiftUI
import WeatherCore

struct ForecastListView: View {
    let forecast: [DayForecast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(forecast, id: \.dt) { dayForecast in
                ForecastRow(forecast: dayForecast)
                    .background(.clear)
            }
        }
    }
}
