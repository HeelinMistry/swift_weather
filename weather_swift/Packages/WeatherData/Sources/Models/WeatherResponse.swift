import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: MainWeather
    let dt: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case dt
        case name
    }
    
    init(
        weather: [Weather],
        main: MainWeather,
        dt: Int,
        name: String
    ) {
        self.weather = weather
        self.main = main
        self.dt = dt
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decode([Weather].self, forKey: .weather)
        main = try values.decode(MainWeather.self, forKey: .main)
        dt = try values.decode(Int.self, forKey: .dt)
        name = try values.decode(String.self, forKey: .name)
    }
}
