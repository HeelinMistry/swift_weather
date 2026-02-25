//
//  WeatherRepositoryTests.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import XCTest
@testable import WeatherData
@testable import WeatherCore

final class WeatherRepositoryTests: XCTestCase {
    var sut: WeatherRepository!
    var networkClient: WeatherNetworkClient!
    var cache: WeatherDiskCache!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        networkClient = WeatherNetworkClient(session: session)
        cache = WeatherDiskCache()
        sut = WeatherRepository(networkClient: networkClient, cache: cache)
    }

    override func tearDown() async throws {
        await cache.clearCache()
        MockURLProtocol.mockResponse = nil
        sut = nil
        try await super.tearDown()
    }

    // MARK: - Tests

    func testFetchWeather_WhenNetworkAndCache_ReturnNetwork() async throws {
        let testKey = "test_api_key"
        WeatherConfig.apiKey = APIKey(testKey)
        let lat = -33.92, lon = 18.42
        let mockDTO = WeatherResponse.mock()
        let encoder = JSONEncoder()
        let data = try encoder.encode(mockDTO)
        let response = HTTPURLResponse(url:
                                        URL(
                                            string: "https://api.openweathermap.org/data/2.5/weather?appid=\(testKey)&units=standard&lat=-33.92&lon=18.42")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        MockURLProtocol.mockResponse = (data, response, nil)

        let result = try await sut.fetchCurrentWeather(lat: lat, lon: lon)
        XCTAssertEqual(result.currentTemp, 25)
    }

    func testFetchWeather_WhenCacheIsFresh_ReturnsCachedDataWithoutCallingNetwork() async throws {
        let lat = -33.92, lon = 18.42
        let fileName = "weather_\(lat)_\(lon)_current"
        let mockDTO = WeatherResponse.mock()
        await cache.save(mockDTO, lat: lat, lon: lon, fileName: fileName)
        MockURLProtocol.mockResponse = (nil, nil, NetworkError.invalidURL)
        let result = try await sut.fetchCurrentWeather(lat: lat, lon: lon)
        XCTAssertEqual(result.currentTemp, 25)
    }

    func testFetchWeather_WhenNetworkFails_ReturnsExpiredCacheFallback() async throws {
        let lat = 51.50, lon = 0.12
        let fileName = "weather_\(lat)_\(lon)_current"
        let mockDTO = WeatherResponse.mock()
        await cache.save(mockDTO, lat: lat, lon: lon, fileName: fileName)
        let response = HTTPURLResponse(url: URL(string: "https://api.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponse = (nil, response, nil)
        let result = try await sut.fetchCurrentWeather(lat: lat, lon: lon)
        XCTAssertEqual(result.currentTemp, 25, "Should have returned cached data after network failed")
    }

    func testFetchWeather_WhenNetworkAndCacheBothFail_ThrowsError() async throws {
        let lat = 0.0, lon = 0.0
        let response = HTTPURLResponse(url: URL(string: "https://api.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponse = (nil, response, nil)
        do {
            _ = try await sut.fetchCurrentWeather(lat: lat, lon: lon)
            XCTFail("Should have thrown error because there is no cache and network failed")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testFetchForecast_WhenNetworkAndCache_ReturnNetwork() async throws {
        let testKey = "test_api_key"
        WeatherConfig.apiKey = APIKey(testKey)
        let lat = -33.92, lon = 18.42
        let mockDTO = ForecastResponse.mock()
        let encoder = JSONEncoder()
        let data = try encoder.encode(mockDTO)
        let response = HTTPURLResponse(url:
                                        URL(
                                            string: "https://api.openweathermap.org/data/2.5/weather?appid=\(testKey)&units=standard&lat=-33.92&lon=18.42")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        MockURLProtocol.mockResponse = (data, response, nil)

        let result = try await sut.fetchWeatherForecast(lat: lat, lon: lon)
        XCTAssertEqual(result.first?.dt, mockDTO.list?.first?.dt)
    }

    func testFetchForecast_WhenCacheIsFresh_ReturnsCachedDataWithoutCallingNetwork() async throws {
        let lat = -33.92, lon = 18.42
        let fileName = "weather_\(lat)_\(lon)_forecast"
        let mockDTO = ForecastResponse.mock()
        await cache.save(mockDTO, lat: lat, lon: lon, fileName: fileName)
        MockURLProtocol.mockResponse = (nil, nil, NetworkError.invalidURL)
        let result = try await sut.fetchWeatherForecast(lat: lat, lon: lon)
        XCTAssertEqual(result.first?.dt, mockDTO.list?.first?.dt)
    }

    func testFetchForecast_WhenNetworkFails_ReturnsExpiredCacheFallback() async throws {
        let lat = 51.50, lon = 0.12
        let fileName = "weather_\(lat)_\(lon)_forecast"
        let mockDTO = ForecastResponse.mock()
        await cache.save(mockDTO, lat: lat, lon: lon, fileName: fileName)
        let response = HTTPURLResponse(url: URL(string: "https://api.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponse = (nil, response, nil)
        let result = try await sut.fetchWeatherForecast(lat: lat, lon: lon)
        XCTAssertEqual(result.first?.dt, mockDTO.list?.first?.dt, "Should have returned cached data after network failed")
    }

    func testFetchForecast_WhenNetworkAndCacheBothFail_ThrowsError() async throws {
        let lat = 0.0, lon = 0.0
        let response = HTTPURLResponse(url: URL(string: "https://api.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockResponse = (nil, response, nil)
        do {
            _ = try await sut.fetchWeatherForecast(lat: lat, lon: lon)
            XCTFail("Should have thrown error because there is no cache and network failed")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
