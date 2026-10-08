//
//  MockWeatherCache.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 08/10/26.
//

import Foundation
@testable import WeatherWise

final class MockWeatherCache: WeatherCache, @unchecked Sendable {
    var cachedForecast: WeatherForecast?
    var savedForecast: WeatherForecast?

    func save(_ forecast: WeatherForecast, latitude: Double, longitude: Double) {
        savedForecast = forecast
    }

    func load(latitude: Double, longitude: Double) -> WeatherForecast? {
        cachedForecast
    }
}
