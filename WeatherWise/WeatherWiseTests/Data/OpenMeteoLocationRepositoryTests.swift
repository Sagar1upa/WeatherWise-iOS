//
//  OpenMeteoLocationRepositoryTests.swift
//  WeatherWiseTests
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Testing
@testable import WeatherWise

struct OpenMeteoLocationRepositoryTests {
    
    @Test
    func searchCitiesMapsDTOToDomainModel() async throws {
        let apiClient = MockAPIClient()
        
        apiClient.response = GeocodingResponseDTO(results: [GeocodingResultDTO(id: 2643743, name: "London", country: "United Kingdom", latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London")])
        
        let sut = OpenMeteoLocationRepository(apiClient: apiClient)
        let result = try await sut.searchCities(query: "London")
        
        #expect(result.count == 1)
        #expect(result[0].id == 2643743)
        #expect(result[0].name == "London")
        #expect(result[0].country == "United Kingdom")
        #expect(result[0].latitude == 51.5074)
        #expect(result[0].longitude == -0.1278)
        #expect(result[0].timezone == "Europe/London")
    }
    
    @Test
    func searchCitiesReturnsEmptyWhenResultsAreNil() async throws {
        let apiClient = MockAPIClient()
        apiClient.response = GeocodingResponseDTO(results: nil)
        let sut = OpenMeteoLocationRepository(apiClient: apiClient)
        let result = try await sut.searchCities(query: "Unknown")
        
        #expect(result.isEmpty)
    }
    
    @Test
    func searchCitiesPropagatesAPIError() async {
        let apiClient = MockAPIClient()
        apiClient.error = APIError.networkUnavailable
        let sut = OpenMeteoLocationRepository(apiClient: apiClient)
        
        await #expect(throws: APIError.networkUnavailable) {
            try await sut.searchCities(query: "London")
        }
    }
}
