//
//  FavouriteLocation.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/23.
//

import Foundation

public struct FavouriteLocation: Identifiable, Codable, Equatable {
    public let id: UUID
    public let name: String
    public let latitude: Double
    public let longitude: Double
    
    public init(id: UUID = UUID(), name: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.latitude = lat
        self.longitude = lon
    }
}
