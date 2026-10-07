//
//  OpenMeteoLocationRepository.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct OpenMeteoLocationRepository: LocationRepository {
    private let apiClient: any APIClient
    
    init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }
    
    func searchCities(query: String) async throws -> [City] {
        
        let endpoint = APIEndpoint.geocoding(query: query, count: 10)
        
        let response: GeocodingResponseDTO = try await apiClient.request(endpoint)
        
        return response.results?.map { result in
            City(id: result.id, name: result.name, country: result.country, latitude: result.latitude, longitude: result.longitude, timezone: result.timezone)
        } ?? []
    }
}
