//
//  NetworkClientTests.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import XCTest
@testable import WeatherData

final class WeatherNetworkClientTests: XCTestCase {
    
    override static func setUp() {
        MockURLProtocol.clearMock()
    }
    
    override static func tearDown() {
        MockURLProtocol.clearMock()
    }
    
    private static let successMockJsonString = """
    {
        "coord": {
            "lon": 0.1278,
            "lat": 51.5074
        },
        "weather": [
            {
                "id": 804,
                "main": "Clouds",
                "description": "overcast clouds",
                "icon": "04d"
            }
        ],
        "base": "stations",
        "main": {
            "temp": 283.97,
            "feels_like": 283.3,
            "temp_min": 283.97,
            "temp_max": 283.97,
            "pressure": 1019,
            "humidity": 84,
            "sea_level": 1019,
            "grnd_level": 1016
        },
        "visibility": 10000,
        "wind": {
            "speed": 4.95,
            "deg": 248,
            "gust": 11.73
        },
        "clouds": {
            "all": 100
        },
        "dt": 1771668942,
        "sys": {
            "country": "GB",
            "sunrise": 1771657326,
            "sunset": 1771694670
        },
        "timezone": 0,
        "id": 7302135,
        "name": "Abbey Wood",
        "cod": 200
    }
    """
    
    private func makeMockClient() -> WeatherNetworkClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return WeatherNetworkClient(session: session)
    }

    private func createSuccessMockResponseData() -> (Data?, HTTPURLResponse?, Error?) {
        let data = Data(Self.successMockJsonString.utf8)
        let response = HTTPURLResponse(url: URL(string: "https://api.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        return (data, response, nil)
    }

    func testFetchSuccess() async throws {
        let client = makeMockClient()
        MockURLProtocol.mockResponse = createSuccessMockResponseData()
        let endpoint = OpenWeatherEndpoint.current(lat: 34.0, lon: -118.0)
        let result: WeatherResponse = try await client.fetch(from: endpoint)
        XCTAssertEqual(result.dt, 1771668942)
        XCTAssertEqual(result.main.temp, 283.97)
        XCTAssertEqual(result.weather.first?.main, "Clouds")
    }
    
    func testFetchServerError_404() async throws {
        let client = makeMockClient()
        let response = HTTPURLResponse(url: URL(string: "https://api.com")!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        MockURLProtocol.mockResponse = (nil, response, nil)

        do {
            let _: WeatherResponse = try await client.fetch(from: OpenWeatherEndpoint.current(lat: 0, lon: 0))
            XCTFail("Expected fetch to throw serverError, but it succeeded.")
        } catch let error as NetworkError {
            if case .serverError(let code) = error {
                XCTAssertEqual(code, 404)
            } else {
                XCTFail("Expected .serverError(404), got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError, got \(type(of: error))")
        }
    }

    func testFetchDecodingError() async throws {
        let client = makeMockClient()
        let malformedJson = Data("{ \"wrong_key\": \"data\" }".utf8)
        let response = HTTPURLResponse(url: URL(string: "https://api.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        MockURLProtocol.mockResponse = (malformedJson, response, nil)
        do {
            let _: WeatherResponse = try await client.fetch(from: OpenWeatherEndpoint.current(lat: 0, lon: 0))
            XCTFail("Should have thrown a decoding error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Expected NetworkError.decodingFailed")
        }
    }
}
