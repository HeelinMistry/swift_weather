//
//  WeatherDataTests.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//

import Foundation
import XCTest
@testable import WeatherData
@testable import WeatherCore

final class WeatherDiskCacheTests: XCTestCase {
    var sut: WeatherDiskCache!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = WeatherDiskCache()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_SaveAndLoad_ReturnsCorrectData() async throws {
        let mockDTO = WeatherResponse.mock()
        let fileName = "test_weather"
        let lat = -33.9249
        let lon = 18.4241
        await sut.save(mockDTO, lat: lat, lon: lon, fileName: fileName)
        let loaded: CacheEntry<WeatherResponse>? = await sut.load(fileName: fileName)
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.lat, lat)
        XCTAssertEqual(loaded?.data.main.temp, mockDTO.main.temp)
        XCTAssertEqual(loaded?.data.dt, 1600000000)
    }

    func test_ExpiredCache_IdentifiesCorrectly() {
        let pastDate = Date().addingTimeInterval(-3600) // 1 hour ago (Expired)
        let entry = CacheEntry(data: "Test", timestamp: pastDate, lat: 0, lon: 0)
        XCTAssertTrue(entry.isExpired, "Cache should be expired after 30 minutes")
    }
    
    func test_LoadCorruptData_ReturnsNil() async throws {
        let fileName = "corrupt_data"
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent("\(fileName).json")
        
        let garbageData = Data("This is not JSON".utf8)
        try garbageData.write(to: url)
        
        let result: CacheEntry<WeatherResponse>? = await sut.load(fileName: fileName)
        
        XCTAssertNil(result, "Loading corrupt data should return nil, not crash.")
    }
}
