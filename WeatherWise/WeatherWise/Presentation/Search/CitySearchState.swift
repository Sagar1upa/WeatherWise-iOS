//
//  CitySearchState.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

enum CitySearchState: Equatable, Sendable {
    case idle
    case searching
    case loaded([City])
    case empty
    case failed(AppError)
}
