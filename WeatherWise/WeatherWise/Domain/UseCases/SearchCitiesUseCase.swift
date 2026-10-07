//
//  SearchCitiesUseCase.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

protocol SearchCitiesUseCase: Sendable {
    func execute(query: String) async throws -> [City]
}

struct DefaultSearchCitiesUseCase: SearchCitiesUseCase {
    private let repository: any LocationRepository
    
    init(repository: any LocationRepository) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [City] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            return []
        }
        
        return try await repository.searchCities(query: trimmedQuery)
    }
}
