//
//  APIEndpoint.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

enum APIEndpoint: Sendable {
    case geocoding(query: String)
    
    case forecast(latitude: Double, longitude: Double)
    
    var url: URL? {
        switch self {
        case let .geocoding(query):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "geocoding-api.open-meteo.com"
            components.path = "/v1/search"
            components.queryItems = [
                URLQueryItem(name: "name", value: query),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "format", value: "json")
            ]
            
            return components.url
            
        case let .forecast(latitude, longitude):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.open-meteo.com"
            components.path = "/v1/forecast"
            components.queryItems = [
                URLQueryItem(name: "latitude", value: String(latitude)),
                URLQueryItem(name: "longitude", value: String(longitude)),
                URLQueryItem(name: "daily", value: ["weather_code", "temperature_2m_max", "temperature_2m_min", "precipitation_probability_max", "precipitation_sum", "snowfall_sum", "wind_speed_10m_max", "sunshine_duration", "uv_index_max"].joined(separator: ",")),
                URLQueryItem(name: "forecast_days", value: "7"),
                URLQueryItem(name: "timezone", value: "auto")
            ]
            
            return components.url
        }
    }
}
