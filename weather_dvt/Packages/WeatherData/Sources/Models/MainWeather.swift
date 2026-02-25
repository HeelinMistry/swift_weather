import Foundation

struct MainWeather: Codable {
	let temp: Double?
    let feels_like: Double?
	let temp_min: Double?
	let temp_max: Double?
	let pressure: Int?
	let humidity: Int?
	let sea_level: Int?
	let grnd_level: Int?

	enum CodingKeys: String, CodingKey {
		case temp
		case feels_like
		case temp_min
		case temp_max
		case pressure
		case humidity
		case sea_level
		case grnd_level
	}
    
    init(
        temp: Double? = nil,
        feels_like: Double? = nil,
        temp_min: Double? = nil,
        temp_max: Double? = nil,
        pressure: Int? = nil,
        humidity: Int? = nil,
        sea_level: Int? = nil,
        grnd_level: Int? = nil
    ) {
        self.temp = temp
        self.feels_like = feels_like
        self.temp_min = temp_min
        self.pressure = pressure
        self.humidity = humidity
        self.sea_level = sea_level
        self.grnd_level = grnd_level
        self.temp_max = temp_max
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		temp = try values.decodeIfPresent(Double.self, forKey: .temp)
		feels_like = try values.decodeIfPresent(Double.self, forKey: .feels_like)
		temp_min = try values.decodeIfPresent(Double.self, forKey: .temp_min)
		temp_max = try values.decodeIfPresent(Double.self, forKey: .temp_max)
		pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
		sea_level = try values.decodeIfPresent(Int.self, forKey: .sea_level)
		grnd_level = try values.decodeIfPresent(Int.self, forKey: .grnd_level)
	}
}
