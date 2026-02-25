//
//  Temp.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/22.
//

import Foundation
struct Temp: Codable {
    let day: Double?
    let min: Double?
    let max: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?

    enum CodingKeys: String, CodingKey {
        case day
        case min
        case max
        case night
        case eve
        case morn 
    }
    
    init(day: Double? = nil, min: Double? = nil, max: Double? = nil, night: Double? = nil, eve: Double? = nil, morn: Double? = nil) {
        self.day = day
        self.min = min
        self.max = max
        self.night = night
        self.eve = eve
        self.morn = morn
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        day = try values.decodeIfPresent(Double.self, forKey: .day)
        min = try values.decodeIfPresent(Double.self, forKey: .min)
        max = try values.decodeIfPresent(Double.self, forKey: .max)
        night = try values.decodeIfPresent(Double.self, forKey: .night)
        eve = try values.decodeIfPresent(Double.self, forKey: .eve)
        morn = try values.decodeIfPresent(Double.self, forKey: .morn)
    }

}
