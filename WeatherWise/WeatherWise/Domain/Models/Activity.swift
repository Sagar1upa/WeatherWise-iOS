//
//  Activity.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

enum Activity: String, CaseIterable, Identifiable, Sendable {
    case skiing = "Skiing"
    case surfing = "Surfing"
    case outdoorSightseeing = "Outdoor Sightseeing"
    case indoorSightseeing = "Indoor Sightseeing"
    
    var id: String {
        rawValue
    }
}
