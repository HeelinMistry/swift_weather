//
//  FavouriteRepositoryTests.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/24.
//
import XCTest
@testable import WeatherData
@testable import WeatherCore
@testable import WeatherCommon

final class FavouriteRepositoryTests: XCTestCase {
    var sut: FavouriteRepository!
    var mockCache: MockWeatherCache!

    override func setUp() {
        super.setUp()
        mockCache = MockWeatherCache()
        sut = FavouriteRepository(cache: mockCache)
    }

    override func tearDown() {
        sut = nil
        mockCache = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testGetFavourites_WhenEmpty_ReturnsEmptyArray() async throws {
        let favourites = try await sut.getFavourites()
        XCTAssertTrue(favourites.isEmpty)
    }

    func testSaveFavourite_SavesCorrectly() async throws {
        let location = FavouriteLocation(name: "Cape Town", lat: -33.92, lon: 18.42)
        try await sut.saveFavourite(location)
        let favourites = try await sut.getFavourites()
        XCTAssertEqual(favourites.count, 1)
        XCTAssertEqual(favourites.first?.name, "Cape Town")
    }

    func testSaveFavourite_WhenDuplicate_DoesNotDuplicate() async throws {
        let location = FavouriteLocation(name: "London", lat: 51.50, lon: 0.12)
        try await sut.saveFavourite(location)
        try await sut.saveFavourite(location)
        let favourites = try await sut.getFavourites()
        XCTAssertEqual(favourites.count, 1, "Should not save the same location twice based on lat/lon")
    }

    func testDeleteFavourite_RemovesLocation() async throws {
        let loc1 = FavouriteLocation(name: "Paris", lat: 48.85, lon: 2.35)
        let loc2 = FavouriteLocation(name: "Berlin", lat: 52.52, lon: 13.40)
        try await sut.saveFavourite(loc1)
        try await sut.saveFavourite(loc2)
        try await sut.deleteFavourite(loc1)
        let favourites = try await sut.getFavourites()
        XCTAssertEqual(favourites.count, 1)
        XCTAssertEqual(favourites.first?.name, "Berlin")
        XCTAssertFalse(favourites.contains(where: { $0.name == "Paris" }))
    }
}
