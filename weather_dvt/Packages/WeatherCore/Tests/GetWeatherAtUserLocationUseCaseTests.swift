//
//  GetWeatherAtUserLocationUseCaseTests.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/22.
//

import XCTest
@testable import WeatherCore

final class GetWeatherAtUserLocationUseCaseTests: XCTestCase {

    private var mockWeatherRepo: MockWeatherRepository!
    private var mockLocationService: MockLocationService!
    private var sut: GetWeatherAtUserLocationUseCase!

    override func setUp() {
        super.setUp()
        mockWeatherRepo = MockWeatherRepository()
        mockLocationService = MockLocationService()
        sut = GetWeatherAtUserLocationUseCase(location: mockLocationService, weather: mockWeatherRepo)
    }

    override func tearDown() {
        mockWeatherRepo = nil
        mockLocationService = nil
        sut = nil
        super.tearDown()
    }

    func testExecute_WhenRepositorySucceeds_ReturnsWeatherEntity() async throws {
        let expectedWeather = CurrentWeather(name: "Centurion", currentTemp: 22, maxTemp: 25, minTemp: 21, condition: .clouds)
        let expectedForecast = [DayForecast(dt: 1772244000, icon: .clouds, temp: 297.82)]
        mockWeatherRepo.weatherResult = .success(expectedWeather)
        mockWeatherRepo.forecastResult = .success(expectedForecast)
        let expectedLocation = (1.0, 2.0)
        mockLocationService.result = .success(expectedLocation)
        let result = try await sut.execute(nil)
        XCTAssertTrue(mockLocationService.fetchCalled, "The repository should have been called.")
        XCTAssertTrue(mockWeatherRepo.fetchCalled, "The repository should have been called.")
        XCTAssertEqual(mockWeatherRepo.lastCoordinates?.lat, expectedLocation.0)
        XCTAssertEqual(result.1.currentTemp, 22)
    }

    func testExecute_WhenLocationRepositoryFails_ThrowsError() async {
        let expectedError = NSError(domain: "Location", code: -1)
        mockLocationService.result = .failure(expectedError)

        do {
            _ = try await sut.execute(nil)
            XCTFail("Should have thrown an error but succeeded instead")
        } catch {
            XCTAssertTrue(mockLocationService.fetchCalled)
            XCTAssertFalse(mockWeatherRepo.fetchCalled)
        }
    }

    func testExecute_WhenWeatherRepositoryFails_ThrowsError() async {
        let expectedLocation = (1.0, 2.0)
        mockLocationService.result = .success(expectedLocation)
        let expectedError = NSError(domain: "Network", code: -1)
        mockWeatherRepo.weatherResult = .failure(expectedError)

        do {
            _ = try await sut.execute(nil)
            XCTFail("Should have thrown an error but succeeded instead")
        } catch {
            XCTAssertTrue(mockLocationService.fetchCalled)
            XCTAssertTrue(mockWeatherRepo.fetchCalled)
        }
    }
}
