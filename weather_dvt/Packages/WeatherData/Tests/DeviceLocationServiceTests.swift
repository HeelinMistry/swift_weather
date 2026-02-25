//
//  DeviceLocationServiceTests.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/22.
//

import XCTest
import CoreLocation
@testable import WeatherData
@testable import WeatherCore

@MainActor
final class DeviceLocationServiceTests: XCTestCase {
    
    var sut: DeviceLocationService!
    
    override func setUp() {
        super.setUp()
        sut = DeviceLocationService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_getCurrentLocation_success() async throws {
        let expectedLat: Double = -25.86
        let expectedLon: Double = 28.18
        let mockLocation = CLLocation(latitude: expectedLat, longitude: expectedLon)
        let locationTask = Task {
            try await sut.getCurrentLocation()
        }
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        sut.locationManager(CLLocationManager(), didUpdateLocations: [mockLocation])
        let result = try await locationTask.value
        XCTAssertEqual(result.lat, expectedLat)
        XCTAssertEqual(result.lon, expectedLon)
    }
    
    func test_getCurrentLocation_failure() async throws {
        let expectedError = CLError(.denied)
        let locationTask = Task {
            try await sut.getCurrentLocation()
        }
        try await Task.sleep(nanoseconds: 100_000_000)
        sut.locationManager(CLLocationManager(), didFailWithError: expectedError)
        do {
            _ = try await locationTask.value
            XCTFail("Should have thrown an error")
        } catch let error as CLError {
            XCTAssertEqual(error.code, .denied)
        }
    }
    
    func test_getCurrentLocation_alreadyInProgress_throwsError() async throws {
        _ = Task { try? await sut.getCurrentLocation() }
        try await Task.sleep(nanoseconds: 100_000_000)
        do {
            _ = try await sut.getCurrentLocation()
            XCTFail("Should have thrown 'already in progress' error")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "LocationServiceError")
            XCTAssertEqual(nsError.code, 1)
        }
    }
}
