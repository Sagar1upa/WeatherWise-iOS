//
//  Untitled.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

@MainActor
final class AppContainer {
    let apiClient: any APIClient
    
    let locationRepository: any LocationRepository
    let weatherRepository: any WeatherRepository
    
    let searchCitiesUseCase: any SearchCitiesUseCase
    let activityRecommendationsUseCase: any GetActivityRecommendationsUseCase
    
    init() {
        let apiClient = URLSessionAPIClient()
        self.apiClient = apiClient
        
        let locationRepository = OpenMeteoLocationRepository(apiClient: apiClient)
        
        self.locationRepository = locationRepository
        self.weatherRepository = OpenMeteoWeatherRepository(apiClient: apiClient, cache: UserDefaultsWeatherCache())
        self.searchCitiesUseCase = DefaultSearchCitiesUseCase(repository: locationRepository)
        
        self.activityRecommendationsUseCase = DefaultGetActivityRecommendationsUseCase()
    }
}
