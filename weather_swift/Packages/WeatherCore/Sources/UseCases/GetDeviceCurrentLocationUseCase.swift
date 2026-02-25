//
//  GetDeviceCurrentLocationUseCase.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/23.
//

import Foundation
import WeatherCommon

public protocol GetDeviceCurrentLocationUseCaseProtocol: Sendable {
    func execute() async throws -> Coord
}

public final class GetDeviceCurrentLocationUseCase: GetDeviceCurrentLocationUseCaseProtocol {
    private let location: any LocationServiceProtocol

    public init(
        location: any LocationServiceProtocol
    ) {
        self.location = location
    }

    public func execute() async throws -> Coord {
        let coordResponse = try await location.getCurrentLocation()
        return Coord(lon: coordResponse.lon, lat: coordResponse.lat)
    }
}
