//
//  WeatherCache.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 08/10/26.
//

import Foundation

protocol WeatherCache: Sendable {
    func save(_ forecast: WeatherForecast, latitude: Double, longitude: Double)
    func load(latitude: Double, longitude: Double) -> WeatherForecast?
}
