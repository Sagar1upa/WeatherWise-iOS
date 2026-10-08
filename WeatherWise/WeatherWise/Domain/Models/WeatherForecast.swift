//
//  WeatherForecast.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct WeatherForecast: Codable, Equatable, Sendable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let days: [WeatherDay]
}
