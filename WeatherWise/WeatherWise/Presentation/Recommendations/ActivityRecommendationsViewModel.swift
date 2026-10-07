//
//  ActivityRecommendationsViewModel.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ActivityRecommendationsViewModel {
    private let weatherRepository: any WeatherRepository
    private let recommendationsUseCase: any GetActivityRecommendationsUseCase
    
    private(set) var state: RecommendationState = .idle
    
    init(weatherRepository: any WeatherRepository, recommendationsUseCase: any GetActivityRecommendationsUseCase) {
        self.weatherRepository = weatherRepository
        self.recommendationsUseCase = recommendationsUseCase
    }
    
    func load(for city: City) async {
        state = .loading
        
        do {
            let forecast = try await weatherRepository.fetchForecast(latitude: city.latitude, longitude: city.longitude)
            let recommendations = recommendationsUseCase.execute(forecast: forecast)
            
            guard !recommendations.isEmpty else {
                state = .failed(.unknown)
                return
            }
            
            state = .loaded(recommendations)
            
        } catch {
            state = .failed(AppError(error: error))
        }
    }
    
    func retry(for city: City) async {
        await load(for: city)
    }
}
