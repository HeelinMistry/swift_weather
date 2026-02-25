//
//  WeatherHomeView.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import SwiftUI
import Combine
import WeatherCore

public struct WeatherHomeView: View {
    @StateObject private var viewModel: WeatherViewModel
    @State private var selectedTab: Int = 0
    
    public init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView { dashboardLayer }
                .tabItem { Label("Dashboard", systemImage: "house.fill") }
                .tag(0)
            
            NavigationView { mapLayer }
                .tabItem { Label("Map", systemImage: "map.fill") }
                .tag(1)
            
            NavigationView { favouritesLayer }
                .tabItem { Label("Favourites", systemImage: "heart.fill") }
                .tag(2)
        }
    }
    
    @ViewBuilder
    private var dashboardLayer: some View {
        switch viewModel.state {
        case .success(let weatherData):
            WeatherDashboard(weather: weatherData)
        case .loading:
            ProgressView("Loading Weather...")
        case .error:
            WeatherError(retryAction: reload)
        default:
            ProgressView().onAppear { reload() }
        }
    }
    
    @ViewBuilder
    private var mapLayer: some View {
        switch viewModel.state {
        case .success(let weatherData):
            WeatherMapView(viewModel: viewModel, currentWeatherData: weatherData)
                .id("\(weatherData.coord.lat)-\(weatherData.coord.lon)")
        case .loading:
            ProgressView("Loading Map Tiles...")
        default:
            Color.gray.opacity(0.2) 
        }
    }
    
    @ViewBuilder
    private var favouritesLayer: some View {
        WeatherFavouritesView(viewModel: viewModel, selectedTab: $selectedTab)
    }
    
    private func reload() {
        viewModel.loadCurrentWeather()
    }
}
