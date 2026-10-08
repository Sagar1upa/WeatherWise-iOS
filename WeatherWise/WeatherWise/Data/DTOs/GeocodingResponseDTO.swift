//
//  GeocodingResponseDTO.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct GeocodingResponseDTO: Codable, Sendable {
    let results: [GeocodingResultDTO]?
}

struct GeocodingResultDTO: Codable, Sendable {
    let id: Int
    let name: String
    let country: String?
    let latitude: Double
    let longitude: Double
    let timezone: String?
}
