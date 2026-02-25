//
//  WeatherConfig.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/23.
//

/// A structure for managing API configuration, specifically for the weather service.
///
/// This includes sensitive information like API keys, which should ideally be managed
/// outside of version control (e.g., via `xcconfig` files) in a production environment.
public struct WeatherConfig {
    /// The API key for accessing the weather service.
    ///
    /// In a production application, this key should be loaded securely from
    /// an environment variable or a configuration file (e.g., `Secrets.xcconfig`)
    /// rather than being hardcoded. The commented-out code provides an example
    /// of how it might be fetched from `Info.plist`.
    public static var apiKey = APIKey("e91334020cca2d91f24bc2dbb47b8847")
}
