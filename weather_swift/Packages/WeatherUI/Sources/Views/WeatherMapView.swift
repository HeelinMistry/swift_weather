//
//  WeatherMapView.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/23.
//

import MapKit
import SwiftUI
import WeatherCore

struct WeatherMapView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State var currentWeatherData: WeatherData
    
    var body: some View {
        ZStack(alignment: .top) {
            WeatherMapBridge(currentData: currentWeatherData)
            .ignoresSafeArea()
            HStack {
                TextField("Search for a city...", text: $viewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .onSubmit {
                        viewModel.performSearch { newData in
                            if let newData = newData {
                                DispatchQueue.main.async {
                                    currentWeatherData = newData
                                }

                            }
                        }
                    }
                Button(action: {
                    viewModel.performSearch { newData in
                        if let newData = newData {
                            DispatchQueue.main.async {
                                self.currentWeatherData = newData
                            }
                        }
                    }
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                })
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}
