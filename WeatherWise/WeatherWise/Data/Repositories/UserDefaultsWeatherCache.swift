//
//  UserDefaultsWeatherCache.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 08/10/26.
//

import Foundation

final class UserDefaultsWeatherCache: WeatherCache, @unchecked Sendable  {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(userDefaults: UserDefaults = .standard, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    func save(_ forecast: WeatherForecast, latitude: Double, longitude: Double) {
        guard let data = try? encoder.encode(CachedForecast(forecast: forecast)) else { return }
        userDefaults.set(data, forKey: cacheKey(latitude: latitude, longitude: longitude))
        
    }

    func load(latitude: Double, longitude: Double) -> WeatherForecast? {
        guard let data = userDefaults.data(forKey: cacheKey(latitude: latitude, longitude: longitude)) else { return nil }
        return try? decoder.decode(CachedForecast.self, from: data).forecast
        
    }

    private func cacheKey(latitude: Double, longitude: Double) -> String {
        "weather.forecast.\(latitude).\(longitude)"
    }
}


private struct CachedForecast: Codable {
    let forecast: WeatherForecast

    init(forecast: WeatherForecast) {
        self.forecast = forecast
    }
}
