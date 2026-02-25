//
//  WeatherViewModel.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import SwiftUI
import WeatherCore
import WeatherCommon
import Combine
import CoreLocation
import CoreMotion
import MapKit

@MainActor
public final class WeatherViewModel: ObservableObject {
    @Published public private(set) var state: WeatherViewState = .idle
    @Published public var searchQuery = ""
    @Published public var favourites: [FavouriteLocation] = []
    
    private let favouriteRepo: any FavouriteRepositoryProtocol
    private let fetchCurrentWeatherUseCase: any GetWeatherAtUserLocationUseCaseProtocol
    private var fetchTask: Task<Void, Never>?
    
    public init(
        fetchCurrentWeatherUseCase: any GetWeatherAtUserLocationUseCaseProtocol,
        favouriteRepo: any FavouriteRepositoryProtocol
    ) {
        self.fetchCurrentWeatherUseCase = fetchCurrentWeatherUseCase
        self.favouriteRepo = favouriteRepo
        Task { await loadFavourites() }
    }
    
    public func loadCurrentWeather() {
        fetchTask?.cancel()
        state = .loading
        fetchTask = Task {
            do {
                Log.ui.debug("FetchCurrentWeatherUseCase executing (Includes Location Auth)")
                let response = try await fetchCurrentWeatherUseCase.execute(nil)
                let coord = response.0
                let weather = response.1
                let forecast = response.2
                if !Task.isCancelled {
                    Log.ui.json("Coord fetched", coord, level: .info)
                    Log.ui.json("Weather fetched", weather, level: .info)
                    Log.ui.json("Forecast fetched", forecast, level: .info)
                    let newData = WeatherData(coord: coord, currentWeather: weather, forecast: forecast)
                    Task { await self.toggleFavourite(data: newData) }
                    self.state = .success(newData)
                }
            } catch {
                if !Task.isCancelled {
                    Log.ui.error("Error fetching weather: \(error.localizedDescription)")
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
    
    func performSearch(completion: @escaping (WeatherData?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                completion(nil)
                return
            }
            
            self.fetchTask?.cancel()
            self.fetchTask = Task {
                do {
                    Log.ui.debug("FetchCurrentWeatherUseCase executing (Includes Location Auth)")
                    let foundCoord = Coord(lon: coordinate.longitude, lat: coordinate.latitude)
                    let response = try await self.fetchCurrentWeatherUseCase.execute(foundCoord)
                    let coord = response.0
                    let weather = response.1
                    let forecast = response.2
                    if !Task.isCancelled {
                        Log.ui.json("Coord fetched", coord, level: .info)
                        Log.ui.json("Weather fetched", weather, level: .info)
                        Log.ui.json("Forecast fetched", forecast, level: .info)

                        let convertedData = WeatherData(coord: coord, currentWeather: weather, forecast: forecast)
                        Task { await self.toggleFavourite(data: convertedData) }
                        self.state = .success(convertedData)
                    
                        completion(convertedData)
                    }
                } catch {
                    if !Task.isCancelled {
                        Log.ui.error("Error fetching weather: \(error.localizedDescription)")
                        self.state = .error(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func loadFavourites() async {
        self.favourites = (try? await favouriteRepo.getFavourites()) ?? []
    }
    
    func toggleFavourite(data: WeatherData) async { 
        let fav = FavouriteLocation(
            name: data.currentWeather.name,
            lat: data.coord.lat,
            lon: data.coord.lon
        )
        
        if favourites.contains(where: { $0.name == fav.name }) {
            try? await favouriteRepo.deleteFavourite(fav)
        } else {
            try? await favouriteRepo.saveFavourite(fav)
        }
        await loadFavourites()
    }
    
    func selectLocation(_ location: FavouriteLocation) {
        let coord = Coord(lon: location.longitude, lat: location.latitude)
        fetchTask?.cancel()
        state = .loading
        fetchTask = Task {
            do {
                let response = try await fetchCurrentWeatherUseCase.execute(coord)
                if !Task.isCancelled {
                    self.state = .success(WeatherData(
                        coord: response.0,
                        currentWeather: response.1,
                        forecast: response.2
                    ))
                }
            } catch {
                if !Task.isCancelled {
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteFavourite(at offsets: IndexSet) {
        let locationsToDelete = offsets.map { favourites[$0] }
        Task {
            for location in locationsToDelete {
                try? await favouriteRepo.deleteFavourite(location)
            }
            await loadFavourites()
        }
    }
}
