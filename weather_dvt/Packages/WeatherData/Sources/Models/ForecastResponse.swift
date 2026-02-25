//
//  ForecastResponse.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/22.
//

import Foundation

struct ForecastResponse: Codable {
    let cnt: Int?
    let list: [List]?
    let cod: String?
    
    enum CodingKeys: String, CodingKey {
        case cnt
        case cod
        case list
    }
    
    init(
        cnt: Int,
        cod: String,
        list: [List]
    ) {
        self.cnt = cnt
        self.cod = cod
        self.list = list
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cnt = try container.decode(Int.self, forKey: .cnt)
        self.cod = try container.decode(String.self, forKey: .cod)
        self.list = try container.decode([List].self, forKey: .list)
    }
}
