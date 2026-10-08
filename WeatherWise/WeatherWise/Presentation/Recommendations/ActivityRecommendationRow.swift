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
        HStack(spacing: 16) {
//            rankView

            activityIcon

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(recommendation.activity.rawValue)
                        .font(.headline)
                    
                    Spacer()

                    scoreView
                }

                Text(recommendation.reason)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 22).fill(.regularMaterial))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.primary.opacity(0.06), lineWidth: 1))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 5)
    }

    private var rankView: some View {
        Text("\(rank)")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.blue)
            .frame(width: 32, height: 32)
            .background(Circle().fill(Color.blue.opacity(0.10)))
    }

    private var activityIcon: some View {
        Image(systemName: iconName)
            .font(.title2)
            .foregroundStyle(.blue)
            .frame(width: 42, height: 42)
            .background(Circle().fill(Color.blue.opacity(0.10)))
    }

    private var scoreView: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("\(recommendation.score)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.blue)

            Text("/100")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var iconName: String {
        switch recommendation.activity {
        case .skiing:
            return "snowflake"

        case .surfing:
            return "water.waves"

        case .outdoorSightseeing:
            return "figure.walk"

        case .indoorSightseeing:
            return "building.2"
        }
    }
}
