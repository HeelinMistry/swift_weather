//
//  DeviceLocationService.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/22.
//

import SwiftUI
import CoreLocation
import WeatherCore
import WeatherCommon

@MainActor
public final class DeviceLocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<(lat: Double, lon: Double), Error>?
    
    nonisolated public override init() {
        super.init()
        // We move the delegate assignment to a MainActor context
        // because manager is isolated to MainActor
        Task { @MainActor in
            manager.delegate = self
        }
    }
    
    public func getCurrentLocation() async throws -> (lat: Double, lon: Double) {
        // Safety check: Prevent Swift crash if called twice before returning
        if continuation != nil {
            Log.networking.warning("Location request already in progress.")
            throw NSError(domain: "LocationServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location request already in progress."])
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        }
    }
    
    // Mark as nonisolated to satisfy the Objective-C delegate protocol,
    // then hop back to the MainActor safely.
    nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            if let location = locations.first, let activeContinuation = self.continuation {
                activeContinuation.resume(returning: (location.coordinate.latitude, location.coordinate.longitude))
                self.continuation = nil
            }
        }
    }
    
    nonisolated public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.continuation?.resume(throwing: error)
            self.continuation = nil
        }
    }
}
