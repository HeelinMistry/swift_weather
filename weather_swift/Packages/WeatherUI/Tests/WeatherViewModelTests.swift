//
//  WeatherViewModelTests.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/21.
//

import XCTest
import Combine
import WeatherCore
@testable import WeatherUI

@MainActor
final class WeatherViewModelTests: XCTestCase {

    private var mockUseCase: MockFetchCurrentWeatherUseCase!
    private var mockFavRepo: MockFavouriteRepository!
    private var sut: WeatherViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCurrentWeatherUseCase()
        mockFavRepo = MockFavouriteRepository()
        sut = WeatherViewModel(fetchCurrentWeatherUseCase: mockUseCase, favouriteRepo: mockFavRepo)
    }

    override func tearDown() {
        mockUseCase = nil
        mockFavRepo = nil
        sut = nil
        super.tearDown()
    }

    func testInitialState_WhenEmpty() {
        mockFavRepo.result = .success([])
        XCTAssertEqual(sut.state, .idle)
    }

    func testLoadCurrentWeatherSuccess() async throws {
        mockFavRepo.result = .success([])
        let expectedWeather = CurrentWeather(name: "West", currentTemp: 25, maxTemp: 28, minTemp: 22, condition: .sunny)
        let expectedForecast = [DayForecast(dt: 1772244000, icon: .rain, temp: 297.82)]
        let expectedCoord = Coord(lon: 0, lat: 0)
        mockUseCase.result = .success((expectedCoord, expectedWeather, expectedForecast))
        let expectation = XCTestExpectation(description: "Wait for success state")
        var cancellables = Set<AnyCancellable>()

        sut.$state
            .sink { state in
                if case .success = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.loadCurrentWeather()

        await fulfillment(of: [expectation], timeout: 1.0)
        if case .success(let weather) = sut.state {
            XCTAssertEqual(weather.currentWeather.currentTemp, 25)
            XCTAssertEqual(weather.currentWeather.name, "West")
        } else {
            XCTFail("State was not success")
        }
    }

//    func testLoadCurrentWeatherFailure() async {
//        let errorMessage = "Not Found"
//        let networkError = NSError(
//            domain: "Network",
//            code: 404,
//            userInfo: [NSLocalizedDescriptionKey: errorMessage]
//        )
//        mockUseCase.result = .failure(networkError)
//        mockFavRepo.result = .success([])
//
//        let expectation = XCTestExpectation(description: "ViewModel should transition to error state")
//        var cancellables = Set<AnyCancellable>()
//
//        sut.$state
//            .dropFirst()
//            .sink { state in
//                if case .error(let receivedMessage) = state {
//                    XCTAssertEqual(receivedMessage, errorMessage)
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//
//        sut.loadCurrentWeather()
//        await fulfillment(of: [expectation], timeout: 2.0)
//        XCTAssertTrue(mockUseCase.executeCalled)
//        if case .error(let message) = sut.state {
//            XCTAssertEqual(message, errorMessage)
//        } else {
//            XCTFail("Final state was not error. Current state: \(sut.state)")
//        }
//    }
    
    func testLoadFavourites_UpdatesState() async {
        let expectedLocation = FavouriteLocation(name: "London", lat: 51.5, lon: 0.1)
        mockFavRepo.result = .success([expectedLocation])
        await sut.loadFavourites()
        XCTAssertEqual(sut.favourites.count, 1)
        XCTAssertEqual(sut.favourites.first?.name, "London")
    }
}
