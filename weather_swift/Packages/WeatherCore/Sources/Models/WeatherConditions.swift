//
//  WeatherConditions.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/22.
//

import SwiftUI

public enum WeatherCondition: String, Encodable, Sendable, Equatable {
    case rain = "Rain"
    case clouds = "cloudy"
    case sunny = "Sunny"
    case unknown

    public init(apiString: String? = nil, iconString: String? = nil) {
        if let icon = iconString {
            switch icon {
            case "09d", "10d", "11d", "13d", "09n", "10n", "11n":
                self = .rain
                return
            case "02d", "03d", "04d", "02n", "03n", "04n":
                self = .clouds
                return
            case "01d", "01n":
                self = .sunny
                return
            default: break
            }
        }

        switch apiString {
        case "Rain", "Drizzle", "Thunderstorm", "Snow":
            self = .rain
        case "Clouds", "Partly Cloudy":
            self = .clouds
        case "Sunny", "Clear":
            self = .sunny
        default:
            self = .unknown
        }
    }
}

public extension WeatherCondition {
    /// A  background to asset controller based on weather condition
    var backgroundName: String {
        switch self {
        case .rain: return "forest_rainy"
        case .clouds: return "forest_cloudy"
        case .sunny: return "forest_sunny"
        case .unknown: return ""
        }
    }
    /// A colour  to asset controller based on weather condition
    var backgroundColour: Color {
        switch self {
        case .rain: return Color("forest_rainy")
        case .clouds: return Color("forest_cloudy")
        case .sunny: return Color("forest_sunny")
        case .unknown: return .orange
        }
    }

    /// A n icon to asset controller based on weather condition
    var weatherIcon: String {
        switch self {
        case .rain: return "ic_rainy"
        case .clouds: return "ic_cloudy"
        case .sunny: return "ic_sunny"
        case .unknown: return ""
        }
    }
}
