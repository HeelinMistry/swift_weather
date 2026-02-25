//
//  WeatherEndpoint.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation

/// A protocol defining the basic requirements for an API endpoint.
public protocol APIEndpoint {
    /// The base URL for the API endpoint.
    var baseURL: URL { get }
    /// The specific path component for the API endpoint.
    var path: String { get }
    /// The HTTP method to be used for the request (e.g., GET, POST).
    var method: HTTPMethod { get }
    /// An array of URL query items to be appended to the URL.
    var queryItems: [URLQueryItem] { get }
}

/// An enumeration defining standard HTTP methods.
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

/// An enumeration representing specific endpoints for the OpenWeatherMap API.
enum OpenWeatherEndpoint: APIEndpoint {
    /// Represents the current weather endpoint.
    /// - Parameters:
    ///   - lat: The latitude for the location.
    ///   - lon: The longitude for the location.
    case current(lat: Double, lon: Double)
    /// Represents the daily weather forecast endpoint.
    /// - Parameters:
    ///   - lat: The latitude for the location.
    ///   - lon: The longitude for the location.
    case forecast(lat: Double, lon: Double)
    /// Represents the daily weather forecast endpoint.
    /// - Parameters:
    ///   - lat: The latitude for the location.
    ///   - lon: The longitude for the location.
    case mapLocation(lat: Double, lon: Double)

    /// The base URL for the OpenWeatherMap API.
    var baseURL: URL { URL(string: "https://api.openweathermap.org/")! }

    /// The HTTP method for all OpenWeatherMap endpoints, which is GET.
    var method: HTTPMethod {
        return .get
    }

    /// The specific path for each OpenWeatherMap endpoint.
    var path: String {
        switch self {
        case .current: return "data/2.5/weather"
        case .forecast: return "data/2.5/forecast/daily"
        case .mapLocation: return "maps/2.0/weather"
        }
    }

    /// The query items required for each OpenWeatherMap endpoint, including API key and location.
    var queryItems: [URLQueryItem] {
        let common = [URLQueryItem(name: "appid", value: WeatherConfig.apiKey.rawValue),
                      URLQueryItem(name: "units", value: "standard")]
        switch self {
        case .current(let lat, let lon), .forecast(let lat, let lon):
            return common + [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)")
            ]
        case .mapLocation(let lat, let lon):
            return common + [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)")
            ]
        }
    }
}

extension APIEndpoint {
    /// Constructs a `URLRequest` based on the endpoint's properties.
    ///
    /// This computed property combines the `baseURL`, `path`, `queryItems`, and `method`
    /// to create a fully formed `URLRequest` ready for network communication.
    ///
    /// - Returns: An optional `URLRequest` if the URL can be constructed successfully, otherwise `nil`.
    var urlRequest: URLRequest? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
