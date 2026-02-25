//
//  Coord.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/22.
//

public struct Coord: Sendable, Codable, Equatable {
    public let lon: Double
    public let lat: Double
    
    enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
    
    public init(lon: Double, lat: Double) {
        self.lon = lon
        self.lat = lat
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lon = try values.decode(Double.self, forKey: .lon)
        lat = try values.decode(Double.self, forKey: .lat)
    }
}
