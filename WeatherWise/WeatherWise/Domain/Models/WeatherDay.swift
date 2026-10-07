//
//  WeatherDay.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct WeatherDay: Identifiable, Equatable, Sendable {
    let id: String
    let date: Date
    let weatherCode: Int
    let maximumTemperature: Double
    let minimumTemperature: Double
    let precipitationProbability: Int
    let precipitation: Double
    let snowfall: Double
    let windSpeed: Double
    let sunshineDuration: TimeInterval
    let uvIndex: Double
}
