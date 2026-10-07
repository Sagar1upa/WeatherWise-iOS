//
//  ActivityRecommendation.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct ActivityRecommendation: Identifiable, Equatable, Sendable {
    let activity: Activity
    let score: Int
    let reason: String
    
    var id: Activity {
        activity
    }
}
