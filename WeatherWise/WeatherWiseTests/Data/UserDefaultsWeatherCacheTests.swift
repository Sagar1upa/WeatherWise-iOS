//
//  UserDefaultsWeatherCacheTests.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 08/10/26.
//

import Foundation
import Testing
@testable import WeatherWise

struct UserDefaultsWeatherCacheTests {
    
    @Test
    func saveAndLoadReturnsSameForecast() {
        let suiteName = "WeatherCacheTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let cache = UserDefaultsWeatherCache(userDefaults: defaults)
        let forecast = makeForecast()
        cache.save(forecast, latitude: forecast.latitude, longitude: forecast.longitude)
        let result = cache.load(latitude: forecast.latitude, longitude: forecast.longitude)

        #expect(result == forecast)
    }

    @Test
    func loadReturnsNilWhenNoForecastIsCached() {
        let suiteName = "WeatherCacheTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let cache = UserDefaultsWeatherCache(userDefaults: defaults)
        let result = cache.load(latitude: 19.0760, longitude: 72.8777)

        #expect(result == nil)
    }

    @Test
    func differentCoordinatesUseDifferentCacheEntries() {
        let suiteName = "WeatherCacheTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let cache = UserDefaultsWeatherCache(userDefaults: defaults)
        let forecast = makeForecast()
        cache.save(forecast, latitude: forecast.latitude, longitude: forecast.longitude)
        let result = cache.load(latitude: 51.5074, longitude: -0.1278)

        #expect(result == nil)
    }

    private func makeForecast() -> WeatherForecast {
        let day = WeatherDay(id: "2026-10-08", date: Date(timeIntervalSince1970: 0), weatherCode: 1, maximumTemperature: 28, minimumTemperature: 20, precipitationProbability: 10, precipitation: 0, snowfall: 0, windSpeed: 15, sunshineDuration: 25_000, uvIndex: 5)

        return WeatherForecast(latitude: 19.0760, longitude: 72.8777, timezone: "Asia/Kolkata", days: [day])
    }
}
