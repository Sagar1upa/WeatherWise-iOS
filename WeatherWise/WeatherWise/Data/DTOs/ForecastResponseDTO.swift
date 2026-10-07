//
//  ForecastResponseDTO.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct ForecastResponseDTO: Codable, Sendable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let daily: DailyForecastDTO
}

struct DailyForecastDTO: Codable, Sendable {
    let time: [String]
    let weatherCode: [Int]
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    let precipitationProbabilityMax: [Int]
    let precipitationSum: [Double]
    let snowfallSum: [Double]
    let windSpeedMax: [Double]
    let sunshineDuration: [Double]
    let uvIndexMax: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case precipitationSum = "precipitation_sum"
        case snowfallSum = "snowfall_sum"
        case windSpeedMax = "wind_speed_10m_max"
        case sunshineDuration = "sunshine_duration"
        case uvIndexMax = "uv_index_max"
    }
}
