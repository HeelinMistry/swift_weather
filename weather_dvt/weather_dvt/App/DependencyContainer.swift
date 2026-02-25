//
//  DependencyContainer.swift
//  WeatherCommon
//
//  Created by Heelin Mistry on 2026/02/21.
//

import WeatherCore
import WeatherData

final class DependencyContainer {
    private lazy var networkClient = WeatherNetworkClient()
    private lazy var cache = WeatherDiskCache()

    /// Provides a repository for handling favourite locations.
    public lazy var favouritesRepository: FavouriteRepositoryProtocol = {
        FavouriteRepository(cache: cache)
    }()
    
    private lazy var weatherRepository: WeatherRepositoryProtocol = {
        WeatherRepository(networkClient: networkClient, cache: cache)
    }()

    private lazy var locationService: LocationServiceProtocol = {
        DeviceLocationService()
    }()

    /// Provides a use case for fetching the current weather at the user's location.
    public var fetchCurrentWeatherUseCase: any GetWeatherAtUserLocationUseCaseProtocol {
        GetWeatherAtUserLocationUseCase(location: locationService, weather: weatherRepository)
    }

    /// Initializes a new dependency container.
    public init() {}
}
