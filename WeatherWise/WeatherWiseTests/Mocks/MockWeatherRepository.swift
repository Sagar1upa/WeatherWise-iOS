//
//  MockWeatherRepository.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
@testable import WeatherWise

final class MockWeatherRepository: WeatherRepository, @unchecked Sendable {
    var forecast: WeatherForecast?
    var error: Error?
    var fetchCallCount = 0
    var lastLatitude: Double?
    var lastLongitude: Double?

    func fetchForecast(latitude: Double, longitude: Double) async throws -> WeatherForecast {
        fetchCallCount += 1
        lastLatitude = latitude
        lastLongitude = longitude

        if let error { throw error }
        guard let forecast else { throw APIError.requestFailed }

        return forecast
    }
}
