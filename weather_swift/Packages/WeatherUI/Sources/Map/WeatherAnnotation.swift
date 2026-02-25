//
//  WeatherAnnotation.swift
//  WeatherUI
//
//  Created by Heelin Mistry on 2026/02/23.
//

import MapKit
import WeatherCore

class WeatherAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var data: WeatherData
    let isHome: Bool
    
    func update(with data: WeatherData) {
        self.data = data

        self.coordinate = CLLocationCoordinate2D(
            latitude: data.coord.lat,
            longitude: data.coord.lon
        )
    }

    var title: String? {
        data.currentWeather.name + ": " + data.currentWeather.currentTemp.displayTemp
    }
    
    init(data: WeatherData, isHome: Bool) {
        self.data = data
        let coord = data.coord
        self.coordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
        self.isHome = isHome
        super.init()
    }
}
