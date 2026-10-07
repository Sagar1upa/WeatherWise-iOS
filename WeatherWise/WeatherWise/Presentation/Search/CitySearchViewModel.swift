//
//  CitySearchViewModel.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class CitySearchViewModel {
    private let searchCitiesUseCase: any SearchCitiesUseCase
    
    private(set) var state: CitySearchState = .idle
    private(set) var query = ""
    
    private var searchTask: Task<Void, Never>?
    
    init(searchCitiesUseCase: any SearchCitiesUseCase) {
        self.searchCitiesUseCase = searchCitiesUseCase
    }
    
    func updateQuery(_ query: String) {
        self.query = query
        searchTask?.cancel()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            state = .idle
            return
        }
        
        guard trimmedQuery.count >= 2 else {
            state = .idle
            return
        }
        
        searchTask = Task { [weak self] in
            guard let self else { return }
            
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await self.searchCities(trimmedQuery)
        }
    }
    
    func retry() {
        guard !query.isEmpty else { return }
        
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            await self.searchCities(query)
        }
    }
    
    private func searchCities(_ query: String) async {
        state = .searching
        
        do {
            let cities = try await searchCitiesUseCase.execute(query: query)
            guard !Task.isCancelled else { return }
            state = cities.isEmpty ? .empty : .loaded(cities)
            
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed(AppError(error: error))
        }
    }
}
