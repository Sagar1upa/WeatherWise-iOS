//
//  RecommendationState.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

enum RecommendationState: Equatable, Sendable {
    case idle
    case loading
    case loaded([ActivityRecommendation])
    case failed(AppError)
}
