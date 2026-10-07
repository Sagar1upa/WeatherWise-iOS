//
//  ActivityRecommendationRow.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import SwiftUI

struct ActivityRecommendationRow: View {
    let rank: Int
    let recommendation: ActivityRecommendation
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            rankView
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(recommendation.activity.rawValue)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(recommendation.score)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Text("Score: \(recommendation.score)/100")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(recommendation.reason)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var rankView: some View {
        Text("\(rank)")
            .font(.headline)
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(.thinMaterial)
            )
    }
}
