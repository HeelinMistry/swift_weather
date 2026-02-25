//
//  Double+Ext.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/23.
//

extension Double {
    /// A central method to format the temperature for display
    public var displayTemp: String {
        return "\(Int(self.rounded()))°"
    }
    
    /// A central method to convert the temperature from kelvin to celcius
    public var formatTemp: Double {
        let celsius = self - 273.15
        return celsius.rounded()
    }
}
