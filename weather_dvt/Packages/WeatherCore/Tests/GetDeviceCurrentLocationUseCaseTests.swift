//
//  GetDeviceCurrentLocationUseCaseTests.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/24.
//

import XCTest
@testable import WeatherCore

final class GetDeviceCurrentLocationUseCaseTests: XCTestCase {
    
    private var mockLocationService: MockLocationService!
    private var sut: GetDeviceCurrentLocationUseCase!
    
    override func setUp() {
        super.setUp()
        mockLocationService = MockLocationService()
        sut = GetDeviceCurrentLocationUseCase(location: mockLocationService)
    }
    
    override func tearDown() {
        mockLocationService = nil
        sut = nil
        super.tearDown()
    }
    
    func testExecute_WhenRepositorySucceeds_ReturnsWeatherEntity() async throws {
        let expectedLocation = (1.0, 2.0)
        mockLocationService.result = .success(expectedLocation)
        let result = try await sut.execute()
        XCTAssertTrue(mockLocationService.fetchCalled, "The repository should have been called.")
        XCTAssertEqual(result.lat, 1.0)
        XCTAssertEqual(result.lon, 2.0)
    }
}
