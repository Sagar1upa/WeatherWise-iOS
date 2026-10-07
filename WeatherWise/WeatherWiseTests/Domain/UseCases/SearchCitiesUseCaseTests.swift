//
//  SearchCitiesUseCaseTests.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Testing
@testable import WeatherWise

struct SearchCitiesUseCaseTests {
    
    @Test
    func executeTrimsQueryBeforeSearching() async throws {
        let repository = MockLocationRepository()
        repository.cities = [
            City(id: 1, name: "London", country: "United Kingdom", latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London")
        ]
        
        let sut = DefaultSearchCitiesUseCase(repository: repository)
        let result = try await sut.execute(query: "  London  ")
        
        #expect(result.count == 1)
        #expect(repository.lastQuery == "London")
    }
    
    @Test
    func executeReturnsEmptyForBlankQuery() async throws {
        let repository = MockLocationRepository()
        let sut = DefaultSearchCitiesUseCase(repository: repository)
        let result = try await sut.execute(query: "   ")
        
        #expect(result.isEmpty)
        #expect(repository.lastQuery == nil)
    }
    
    @Test
    func executePropagatesRepositoryError() async {
        let repository = MockLocationRepository()
        repository.error = APIError.networkUnavailable
        
        let sut = DefaultSearchCitiesUseCase(repository: repository)
        
        await #expect(throws: APIError.networkUnavailable) {
            try await sut.execute(query: "London")
        }
    }
}

private final class MockLocationRepository: LocationRepository, @unchecked Sendable {
    var cities: [City] = []
    var error: Error?
    var lastQuery: String?
    
    func searchCities(query: String) async throws -> [City] {
        lastQuery = query
        
        if let error {
            throw error
        }
        
        return cities
    }
}
