//
//  WeatherRepository.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

protocol WeatherRepository: Sendable {
    func fetchForecast(
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherForecast
}
