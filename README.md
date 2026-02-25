# Weather Project

## App Notes
- App will request permission for location. An error screen appears allowing retries, on simulator set the GPS in Xcode while running
- App auto saves first location to favourites.
- Can use the map to search, it returns the first result the query updates with weather data, auto save, can shift to dashboard to view forecast or favourites to remove(swipe to remove).
- In favourites selecting a location updates the data (auto navigates to dashboard) and when navigating to the map will center around the new location.
- Weather data is stored in caching directory, with internal expiry after 30min.
- Favourite data is stored in persistence directory, will not be forgotten.

## Developer Notes
### SwiftLint Usage
We use SwiftLint to enforce style. It runs automatically during build phases.
- **To fix simple violations:** run `swiftlint --fix` in the root directory.
- **Rules:** Defined in `.swiftlint.yml`.

### Packages
We use packages to ensure UI Layer -> Core Layer -> Data Layer -> Repository/Cache
- WeatherCommon
- WeatherCore
- WeatherData
- WeatherUI
We use UseCase to communicate from UI to Core

### Documentation
CMD+^+shift+D (Build Xcode docc)

API Documentation is auto-generated and hosted via GitHub Pages

Added unit test coverage functionality .github/workflows/run_tests.yml this suppose to run all unit tests and only allows minimum_coverage of 80, that is abit random in what it chooses to cover. But very nice output on the PR's

Added tagging functionality .github/workflows/tag_release.yml this tags and allows for a downloadable source

Project structure in readme is auto generated to give a high level of of files/folders, just handy and free to do.

## Project Structure
The WeatherCore defines the WeatherRepositoryProtocol. WeatherData package then implements that protocol. The rest of the app (like WeatherUI) only ever talks to the Core Protocols. This means you could swap WeatherData for a MockData package or a LocalDatabaseData package, and WeatherCore wouldn't have to change a single line of code.

Mappers/ folder in WeatherData. This is the most critical part. It takes raw API DTOs (Data Transfer Objects) from the web and converts them into the "Pure" models found in WeatherCore.

By keeping WeatherCore independent, you ensure that the UI doesn't accidentally depend on the Networking library (URLSession/AlamoFire) and the Networking library doesn't depend on SwiftUI.

Caching is done storing to a local file on device, implemented so this can implement all 3 [swiftdata, coredata] and each can be used interchangeable
``
```
- weather_dvt/
- weather_dvt.xctestplan
- weather_dvt/
    - App/
        - DependencyContainer.swift
        - WeatherDvtApp.swift
- Packages/
    - WeatherCore/
        - Package.swift
        - Tests/
            - GetWeatherAtUserLocationUseCaseTests.swift
            - GetDeviceCurrentLocationUseCaseTests.swift
            - Mocks/
                - MockLocationRepository.swift
                - MockLocationService.swift
                - MockWeatherRepository.swift
        - Sources/
            - Models/
                - WeatherConditions.swift
                - CurrentWeather.swift
                - FavouriteLocation.swift
                - DayForecast.swift
                - Coord.swift
            - Extensions/
                - Double+Ext.swift
                - Int+Ext.swift
            - Protocols/
                - WeatherRepositoryProtocol.swift
                - FavouriteRepositoryProtocol.swift
                - LocationServiceProtocol.swift
            - UseCases/
                - GetDeviceCurrentLocationUseCase.swift
                - GetWeatherAtUserLocationUseCase.swift
    - WeatherCommon/
        - Package.swift
        - Sources/
            - Logging/
                - Logging.swift
                - PrettyJSON.swift
                - Log+JSON.swift
    - WeatherUI/
        - Package.swift
        - Tests/
            - WeatherViewModelTests.swift
            - Mock/
                - MockFavouriteRepository.swift
                - MockFetchCurrentWeatherUseCase.swift
                - MockWeatherRepository.swift
        - Sources/
            - ViewModels/
                - WeatherViewModel.swift
                - WeatherData.swift
                - WeatherViewState.swift
            - Components/
                - CurrentWeatherHeaderView.swift
                - CurrentWeatherView.swift
                - ForecastListView.swift
                - ForecastRow.swift
                - CurrentWeatherTemperatureView.swift
            - Map/
                - WeatherAnnotation.swift
                - WeatherMapBridge.swift
            - Views/
                - WeatherDashboard.swift
                - WeatherMapView.swift
                - WeatherFavouritesView.swift
                - WeatherError.swift
                - WeatherHomeView.swift
    - WeatherData/
        - Package.swift
        - Tests/
            - DeviceLocationServiceTests.swift
            - NetworkClientTests.swift
            - FavouriteRepositoryTests.swift
            - WeatherRepositoryTests.swift
            - WeatherCacheTests.swift
            - Mocks/
                - MockURLProtocol.swift
                - MockWeatherCache.swift
                - WeatherResponseMock.swift
                - ForecastResponseMock.swift
        - Sources/
            - Config/
                - WeatherConfig.swift
            - Location/
                - DeviceLocationService.swift
            - Networking/
                - WeatherEndpoint.swift
                - WeatherNetworkClient.swift
            - Repositories/
                - WeatherRepository.swift
                - FavouriteRepository.swift
            - Models/
                - WeatherResponse.swift
                - Temp.swift
                - ForecastResponse.swift
                - APIKey.swift
                - List.swift
                - Weather.swift
                - MainWeather.swift
            - Extensions/
                - Double+Ext.swift
                - APIEndpoint+Ext.swift
            - Persistence/
                - CacheEntry.swift
                - WeatherCache.swift
            - Mappers/
                - ForecastResponseMapper.swift
                - WeatherResponseMapper.swift
            - Errors/
                - NetworkErrors.swift
```
``
