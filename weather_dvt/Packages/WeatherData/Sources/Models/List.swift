//
//  List.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/22.
//

import Foundation
struct List: Codable {
    let dt: Int?
    let temp: Temp?
    let weather: [Weather]?

    enum CodingKeys: String, CodingKey {

        case dt
        case temp
        case weather
    }
    
    init (dt: Int? = nil, temp: Temp? = nil, weather: [Weather]? = nil) {
        self.dt = dt
        self.temp = temp
        self.weather = weather
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decodeIfPresent(Int.self, forKey: .dt)
        temp = try values.decodeIfPresent(Temp.self, forKey: .temp)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
    }

}
