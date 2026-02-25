//
//  WeatherNetworkClient.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation
import WeatherCommon
import os

/// A network client for making API requests to a weather service.
///
/// This actor provides a generic `fetch` method to handle API requests,
/// decode the responses, and manage network-related errors.
public actor WeatherNetworkClient {
    private let session: URLSession
    private let logger = Logger(subsystem: "com.weather.app", category: "Networking")
    
    /// Initializes a new `WeatherNetworkClient` instance.
    /// - Parameter session: The `URLSession` to use for network requests. Defaults to `URLSession.shared`.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from endpoint: APIEndpoint) async throws -> T {
        guard let request = endpoint.urlRequest else {
            Log.networking.fault("Invalid URL for path: \(endpoint.path)")
            throw NetworkError.invalidURL
        }
        
        let method = endpoint.method.rawValue
        Log.networking.debug("\(method) Requesting: \(endpoint.redactedURLString)")
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            // This case should ideally not happen with URLSession.data(for:), as it typically returns HTTPURLResponse for http/https.
            // A status code of 0 is used to indicate an unknown server error when the response type is unexpected.
            throw NetworkError.serverError(0)
        }
        if !(200...299).contains(httpResponse.statusCode) {
            Log.networking.error("Status Code: \(httpResponse.statusCode) for \(endpoint.path)")
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            Log.networking.info("Successfully decoded \(T.self)")
            return decodedData
        } catch {
            Log.networking.error("Decoding failed for \(T.self): \(error.localizedDescription)")
            throw NetworkError.decodingFailed
        }
    }
}
