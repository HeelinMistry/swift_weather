//
//  Double+Ext.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/22.
//

extension Double {
    /// A centralized display formatter for temperature.
    public var displayTemp: String {
        return "\(Int(self.rounded()))°"
    }
}
