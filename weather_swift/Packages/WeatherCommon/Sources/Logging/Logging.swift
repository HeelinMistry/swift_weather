//
//  Logging.swift
//  WeatherCommon
//
//  Created by Heelin Mistry on 2026/02/20.
//

import OSLog
import Foundation

/// A centralized logging utility providing categorized loggers for different parts of the application.
public enum Log {
    /// Dynamically grab the bundle ID or fallback to a string
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.weather.app"

    /// Logs related to API calls, connectivity, and data transfer.
    public static let networking = Logger(subsystem: subsystem, category: "Networking")
    
    /// Logs related to Disk caching and persistence.
    public static let persistence = Logger(subsystem: subsystem, category: "Persistence")
    
    /// Logs related to View Model state changes and View lifecycle.
    public static let ui = Logger(subsystem: subsystem, category: "UI")
}
