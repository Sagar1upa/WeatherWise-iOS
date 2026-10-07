//
//  GetActivityRecommendationsUseCaseTests.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Testing
@testable import WeatherWise

struct GetActivityRecommendationsUseCaseTests {
    
    private let sut = DefaultGetActivityRecommendationsUseCase()
    
    @Test
    func executeReturnsAllActivities() {
        let forecast = makeForecast()
        
        let result = sut.execute(forecast: forecast)
        
        #expect(result.count == Activity.allCases.count)
    }
    
    @Test
    func executeRanksActivitiesByScoreDescending() {
        let forecast = makeForecast()
        
        let result = sut.execute(forecast: forecast)
        
        for index in 0..<(result.count - 1) {
            #expect(result[index].score >= result[index + 1].score)
        }
    }
    
    @Test
    func executeReturnsEmptyForEmptyForecast() {
        let forecast = WeatherForecast(latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London", days: [])
        let result = sut.execute(forecast: forecast)
        
        #expect(result.isEmpty)
    }
    
    @Test
    func snowyColdWeatherFavorsSkiing() {
        let forecast = makeForecast(weatherCode: 71, maximumTemperature: 2, minimumTemperature: -5, precipitationProbability: 20, precipitation: 2, snowfall: 10, windSpeed: 15, sunshineDuration: 10_000, uvIndex: 1)
        
        let result = sut.execute(forecast: forecast)
        
        let skiing = result.first {
            $0.activity == .skiing
        }
        
        #expect(skiing != nil)
        #expect(skiing!.score >= 70)
    }
    
    @Test
    func rainyWeatherFavorsIndoorSightseeing() {
        let forecast = makeForecast(weatherCode: 63, maximumTemperature: 12, minimumTemperature: 8, precipitationProbability: 90, precipitation: 15, snowfall: 0, windSpeed: 20, sunshineDuration: 2_000, uvIndex: 2)
        
        let result = sut.execute(forecast: forecast)
        
        let indoor = result.first {
            $0.activity == .indoorSightseeing
        }
        
        #expect(indoor != nil)
        #expect(indoor!.score >= 70)
    }
    
    @Test
    func recommendationScoreIsWithinValidRange() {
        let forecast = makeForecast()
        
        let result = sut.execute(forecast: forecast)
        
        for recommendation in result {
            #expect(recommendation.score >= 0)
            #expect(recommendation.score <= 100)
        }
    }
    
    private func makeForecast(weatherCode: Int = 1, maximumTemperature: Double = 22, minimumTemperature: Double = 14, precipitationProbability: Int = 10, precipitation: Double = 0, snowfall: Double = 0, windSpeed: Double = 15, sunshineDuration: TimeInterval = 25_000, uvIndex: Double = 5) -> WeatherForecast {
        let day = WeatherDay(id: "2026-10-07", date: Date(timeIntervalSince1970: 0), weatherCode: weatherCode, maximumTemperature: maximumTemperature, minimumTemperature: minimumTemperature, precipitationProbability: precipitationProbability, precipitation: precipitation, snowfall: snowfall, windSpeed: windSpeed, sunshineDuration: sunshineDuration, uvIndex: uvIndex)
        
        return WeatherForecast(latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London", days: [day])
    }
}
