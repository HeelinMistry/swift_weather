//
//  WeatherRepository.swift
//  WeatherData
//
//  Created by Heelin Mistry on 2026/02/20.
//
import Foundation
import WeatherCore
import WeatherCommon

public final class WeatherRepository: WeatherRepositoryProtocol {
    private let networkClient: WeatherNetworkClient
    private let cache: WeatherCacheService

    public init(networkClient: WeatherNetworkClient, cache: WeatherCacheService) {
        self.networkClient = networkClient
        self.cache = cache
    }

    public func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CurrentWeather {
        let fileName = "weather_\(lat)_\(lon)_current"

        let cached: CacheEntry<WeatherResponse>? = await cache.load(fileName: fileName)
        if let cached = cached, !cached.isExpired {
            return cached.data.toEntity()
        }
        do {
            let dto: WeatherResponse = try await networkClient.fetch(from: OpenWeatherEndpoint.current(lat: lat, lon: lon))
            Log.networking.json("Successfully fetched current weather", dto)
            await cache.save(dto, lat: lat, lon: lon, fileName: fileName)
            return dto.toEntity()
        } catch {
            if let expiredData = cached?.data {
                return expiredData.toEntity()
            }
            throw error
        }
    }

    public func fetchWeatherForecast(lat: Double, lon: Double) async throws -> [DayForecast] {
        let fileName = "weather_\(lat)_\(lon)_forecast"

        let cached: CacheEntry<ForecastResponse>? = await cache.load(fileName: fileName)
        if let cached = cached, !cached.isExpired {
            return cached.data.toEntity()
        }
        do {
            let dto: ForecastResponse = try await networkClient.fetch(from: OpenWeatherEndpoint.forecast(lat: lat, lon: lon))
            Log.networking.json("Successfully fetched forecast", dto)
            await cache.save(dto, lat: lat, lon: lon, fileName: fileName)
            return dto.toEntity()
        } catch {
            if let expiredData = cached?.data {
                return expiredData.toEntity()
            }
            throw error
        }
    }
}
