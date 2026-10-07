//
//  CitySearchViewModelTests.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Testing
@testable import WeatherWise

@MainActor
struct CitySearchViewModelTests {

    @Test
    func initialStateIsIdle() {
        let repository = MockLocationRepository()

        let sut = CitySearchViewModel(searchCitiesUseCase: DefaultSearchCitiesUseCase(repository: repository))

        #expect(sut.state == .idle)
        #expect(sut.query.isEmpty)
    }

    @Test
    func blankQueryResetsStateToIdle() {
        let repository = MockLocationRepository()

        let sut = CitySearchViewModel(searchCitiesUseCase: DefaultSearchCitiesUseCase(repository: repository))

        sut.updateQuery("London")
        sut.updateQuery("")

        #expect(sut.state == .idle)
        #expect(sut.query.isEmpty)
    }

    @Test
    func singleCharacterQueryDoesNotSearch() async {
        let repository = MockLocationRepository()

        let sut = CitySearchViewModel(searchCitiesUseCase: DefaultSearchCitiesUseCase(repository: repository))

        sut.updateQuery("L")

        try? await Task.sleep(for: .milliseconds(400))

        #expect(repository.searchCallCount == 0)
        #expect(sut.state == .idle)
    }

    @Test
    func validQueryLoadsCities() async {
        let repository = MockLocationRepository()

        repository.cities = [City(id: 2643743, name: "London", country: "United Kingdom", latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London")]

        let sut = CitySearchViewModel(searchCitiesUseCase: DefaultSearchCitiesUseCase(repository: repository))

        sut.updateQuery("London")

        try? await Task.sleep(for: .milliseconds(500))

        guard case let .loaded(cities) = sut.state else {
            Issue.record("Expected loaded state")
            return
        }

        #expect(cities.count == 1)
        #expect(cities.first?.name == "London")
    }

    @Test
    func validQueryReturnsEmptyStateWhenNoCitiesFound() async {
        let repository = MockLocationRepository()

        repository.cities = []

        let sut = CitySearchViewModel(searchCitiesUseCase: DefaultSearchCitiesUseCase(repository: repository))

        sut.updateQuery("UnknownCity")

        try? await Task.sleep(for: .milliseconds(500))

        #expect(sut.state == .empty)
    }

    @Test
    func searchFailureChangesStateToFailed() async {
        let repository = MockLocationRepository()
        repository.error = APIError.networkUnavailable

        let sut = CitySearchViewModel(searchCitiesUseCase: DefaultSearchCitiesUseCase(repository: repository))

        sut.updateQuery("London")

        try? await Task.sleep(for: .milliseconds(500))

        #expect(
            sut.state == .failed(.networkUnavailable)
        )
    }

    @Test
    func retrySearchesCurrentQuery() async {
        let repository = MockLocationRepository()

        repository.cities = [City(id: 2643743, name: "London", country: "United Kingdom", latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London")]

        let sut = CitySearchViewModel(searchCitiesUseCase: DefaultSearchCitiesUseCase(repository: repository))
        sut.updateQuery("London")

        try? await Task.sleep(for: .milliseconds(500))

        let firstCallCount = repository.searchCallCount

        sut.retry()

        try? await Task.sleep(for: .milliseconds(100))

        #expect(repository.searchCallCount == firstCallCount + 1)
    }
}

@MainActor
private final class MockLocationRepository: LocationRepository, @unchecked Sendable{
    var cities: [City] = []
    var error: Error?
    var searchCallCount = 0

    func searchCities(query: String) async throws -> [City] {
        searchCallCount += 1

        if let error { throw error }

        return cities
    }
}
