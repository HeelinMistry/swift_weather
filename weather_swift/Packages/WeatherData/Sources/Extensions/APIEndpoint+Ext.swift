//
//  APIEndpoint+Ext.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/23.
//

import Foundation 

extension APIEndpoint {
    /// A computed property that provides a redacted version of the URL string for logging and debugging.
    ///
    /// This property ensures that sensitive information, such as the `appid` query parameter,
    /// is masked with asterisks before being exposed in logs or other output.
    ///
    /// - Returns: A string representation of the URL with sensitive parameters redacted,
    ///   or "Invalid URL" if the `urlRequest` or its `url` cannot be formed.
    var redactedURLString: String {
        guard let url = urlRequest?.url?.absoluteString else { return "Invalid URL" }
        // Redacts the 'appid' query parameter to prevent logging of API keys.
        return url.replacingOccurrences(of: #"appid=[^&]+"#, with: "appid=********", options: .regularExpression)
    }
}
