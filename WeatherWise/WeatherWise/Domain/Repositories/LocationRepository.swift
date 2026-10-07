//
//  LocationRepository.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

protocol LocationRepository: Sendable {
    func searchCities(query: String) async throws -> [City]
}
