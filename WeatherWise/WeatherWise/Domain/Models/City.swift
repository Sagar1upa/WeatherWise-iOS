//
//  City.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct City: Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    let timezone: String?
    
    var displayName: String {
        "\(name), \(country)"
    }
}
