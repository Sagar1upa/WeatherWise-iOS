//
//  GetActivityRecommendationsUseCase.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

protocol GetActivityRecommendationsUseCase: Sendable {
    func execute(forecast: WeatherForecast) -> [ActivityRecommendation]
}

struct DefaultGetActivityRecommendationsUseCase: GetActivityRecommendationsUseCase {
    
    init() {}
    
    func execute(forecast: WeatherForecast) -> [ActivityRecommendation] {
        guard !forecast.days.isEmpty else {
            return []
        }
        
        let recommendations = Activity.allCases.map { activity in
            makeRecommendation(for: activity, days: forecast.days)
        }
        
        return recommendations.sorted {
            if $0.score == $1.score {
                return $0.activity.rawValue < $1.activity.rawValue
            }
            
            return $0.score > $1.score
        }
    }
    
    private func makeRecommendation(for activity: Activity, days: [WeatherDay]) -> ActivityRecommendation {
        let dailyScores = days.map {
            score(activity: activity, weather: $0)
        }
        
        let totalScore = dailyScores.reduce(0, +)
        let averageScore = totalScore / dailyScores.count
        
        return ActivityRecommendation(activity: activity, score: averageScore, reason: reason(for: activity, days: days, score: averageScore))
    }
    
    private func score(activity: Activity, weather: WeatherDay) -> Int {
        
        switch activity {
        case .skiing:
            return skiingScore(weather)
        case .surfing:
            return surfingScore(weather)
        case .outdoorSightseeing:
            return outdoorSightseeingScore(weather)
        case .indoorSightseeing:
            return indoorSightseeingScore(weather)
        }
    }
    
    private func skiingScore(_ weather: WeatherDay) -> Int {
        var score = 0
        
        if weather.snowfall > 0 {
            score += 35
        }
        
        if weather.minimumTemperature <= 2 {
            score += 20
        }
        
        if weather.maximumTemperature <= 8 {
            score += 15
        }
        
        if weather.precipitationProbability <= 50 {
            score += 10
        }
        
        if weather.windSpeed <= 35 {
            score += 10
        }
        
        return min(score, 100)
    }
    
    private func surfingScore(_ weather: WeatherDay) -> Int {
        var score = 0
        
        if weather.maximumTemperature >= 15 {
            score += 25
        }
        
        if weather.maximumTemperature >= 20 {
            score += 15
        }
        
        if weather.windSpeed <= 30 {
            score += 20
        }
        
        if weather.precipitationProbability <= 40 {
            score += 15
        }
        
        if weather.sunshineDuration >= 14_400 {
            score += 15
        }
        
        return min(score, 100)
    }
    
    private func outdoorSightseeingScore(_ weather: WeatherDay) -> Int {
        var score = 0
        
        if weather.maximumTemperature >= 12 && weather.maximumTemperature <= 30 {
            score += 30
        }
        
        if weather.precipitationProbability <= 20 {
            score += 25
        } else if weather.precipitationProbability <= 40 {
            score += 15
        }
        
        if weather.windSpeed <= 25 {
            score += 20
        }
        
        if weather.sunshineDuration >= 14_400 {
            score += 15
        }
        
        if weather.uvIndex <= 7 {
            score += 10
        }
        
        return min(score, 100)
    }
    
    private func indoorSightseeingScore(_ weather: WeatherDay) -> Int {
        var score = 20
        
        if weather.precipitationProbability >= 60 {
            score += 30
        } else if weather.precipitationProbability >= 40 {
            score += 20
        }
        
        if weather.precipitation >= 5 {
            score += 20
        }
        
        if weather.maximumTemperature < 8 || weather.maximumTemperature > 32 {
            score += 15
        }
        
        if weather.windSpeed > 40 {
            score += 15
        }
        
        return min(score, 100)
    }
    
    private func reason(for activity: Activity, days: [WeatherDay], score: Int) -> String {
        
        guard let representativeDay = days.max(by: { self.score(activity: activity, weather: $0) < self.score(activity: activity, weather: $1)}) else {
            return "Based on the available forecast."
        }
        
        switch activity {
        case .skiing:
            if representativeDay.snowfall > 0 {
                return "Cold conditions with snowfall make skiing favorable."
            }
            
            return "Cool temperatures provide better conditions for skiing."
            
        case .surfing:
            if representativeDay.maximumTemperature >= 20 &&
                representativeDay.windSpeed <= 30 {
                return "Warm conditions with moderate wind make surfing favorable."
            }
            
            return "Weather conditions provide moderate suitability for surfing."
            
        case .outdoorSightseeing:
            if representativeDay.precipitationProbability <= 20 {
                return "Low precipitation probability and comfortable conditions favor outdoor activities."
            }
            
            return "The forecast provides moderate conditions for outdoor sightseeing."
            
        case .indoorSightseeing:
            if representativeDay.precipitationProbability >= 60 {
                return "Higher precipitation probability makes indoor activities a good alternative."
            }
            
            return "Indoor activities provide a reliable option when outdoor conditions are less favorable."
        }
    }
}
