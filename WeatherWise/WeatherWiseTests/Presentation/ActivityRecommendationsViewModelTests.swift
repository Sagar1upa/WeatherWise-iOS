//
//  ActivityRecommendationsViewModelTests.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Testing
@testable import WeatherWise

@MainActor
struct ActivityRecommendationsViewModelTests {

    @Test
    func initialStateIsIdle() {
        let weatherRepository = MockWeatherRepository()

        let sut = ActivityRecommendationsViewModel(weatherRepository: weatherRepository, recommendationsUseCase: DefaultGetActivityRecommendationsUseCase())

        #expect(sut.state == .idle)
    }

    @Test
    func loadChangesStateToLoaded() async {
        let weatherRepository = MockWeatherRepository()
        weatherRepository.forecast = makeForecast()

        let sut = ActivityRecommendationsViewModel(weatherRepository: weatherRepository, recommendationsUseCase: DefaultGetActivityRecommendationsUseCase())

        await sut.load(for: makeCity())

        guard case let .loaded(recommendations) = sut.state else {
            Issue.record("Expected loaded state")
            return
        }

        #expect(recommendations.count == Activity.allCases.count)
        #expect(weatherRepository.fetchCallCount == 1)
    }

    @Test
    func loadPassesCityCoordinatesToRepository() async {
        let weatherRepository = MockWeatherRepository()
        weatherRepository.forecast = makeForecast()

        let city = makeCity()

        let sut = ActivityRecommendationsViewModel(weatherRepository: weatherRepository, recommendationsUseCase: DefaultGetActivityRecommendationsUseCase())

        await sut.load(for: city)

        #expect(weatherRepository.lastLatitude == city.latitude)
        #expect(weatherRepository.lastLongitude == city.longitude)
    }

    @Test
    func loadChangesStateToFailedWhenRepositoryFails() async {
        let weatherRepository = MockWeatherRepository()
        weatherRepository.error = APIError.networkUnavailable

        let sut = ActivityRecommendationsViewModel(weatherRepository: weatherRepository, recommendationsUseCase: DefaultGetActivityRecommendationsUseCase())

        await sut.load(for: makeCity())

        #expect(sut.state == .failed(.networkUnavailable))
    }

    @Test
    func retryFetchesForecastAgain() async {
        let weatherRepository = MockWeatherRepository()
        weatherRepository.forecast = makeForecast()

        let sut = ActivityRecommendationsViewModel(weatherRepository: weatherRepository, recommendationsUseCase: DefaultGetActivityRecommendationsUseCase())

        let city = makeCity()

        await sut.load(for: city)
        await sut.retry(for: city)

        #expect(weatherRepository.fetchCallCount == 2)
    }

    private func makeCity() -> City {
        City(id: 2643743, name: "London", country: "United Kingdom", latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London")
    }

    private func makeForecast() -> WeatherForecast {
        let day = WeatherDay(id: "2026-10-07", date: Date(timeIntervalSince1970: 0), weatherCode: 1, maximumTemperature: 22, minimumTemperature: 14, precipitationProbability: 10, precipitation: 0, snowfall: 0, windSpeed: 15, sunshineDuration: 25_000, uvIndex: 5)

        return WeatherForecast(latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London", days: [day])
    }
}
