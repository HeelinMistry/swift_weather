//
//  APIKey.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/23.
//

import Foundation

/// A wrapper struct for API keys, providing a way to obscure the raw value
/// in console output for security and privacy.
public struct APIKey: CustomStringConvertible, CustomDebugStringConvertible {
    private let value: String
    
    /// Initializes a new APIKey with the given string value.
    /// - Parameter value: The raw string value of the API key.
    public init(_ value: String) {
        self.value = value
    }
    
    /// The raw string value of the API key.
    ///
    /// Use this property when you need the actual key value for network requests.
    public var rawValue: String { value }
    
    /// A textual representation of the API key, suitable for console output.
    ///
    /// This property returns "********" to obscure the actual key value.
    public var description: String { "********" }
    
    /// A textual representation of the API key, suitable for debugging.
    ///
    /// This property returns "********" to obscure the actual key value during debugging.
    public var debugDescription: String { "********" }
}
