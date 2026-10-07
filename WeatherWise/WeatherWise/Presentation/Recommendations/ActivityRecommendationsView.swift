//
//  ActivityRecommendationsView.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import SwiftUI

struct ActivityRecommendationsView: View {
    let city: City
    
    var body: some View {
        Text(city.displayName)
            .navigationTitle("Recommendations")
            .navigationBarTitleDisplayMode(.inline)
    }
}
