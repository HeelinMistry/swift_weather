//
//  Int+Ext.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/23.
//

import Foundation

extension Int {
    /// A centralized display formatter for epochs to days.
    public func toDayName() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
