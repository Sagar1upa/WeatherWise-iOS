//
//  OpenMeteoWeatherRepositoryTests.swift
//  WeatherWiseTests
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
import Testing
@testable import WeatherWise

struct OpenMeteoWeatherRepositoryTests {
    
    @Test
    func fetchForecastMapsDTOToDomainModel() async throws {
        let apiClient = MockAPIClient()
        apiClient.response = makeForecastResponse()
        let sut = OpenMeteoWeatherRepository(apiClient: apiClient)
        
        let result = try await sut.fetchForecast(latitude: 51.5074, longitude: -0.1278)
        
        #expect(result.latitude == 51.5074)
        #expect(result.longitude == -0.1278)
        #expect(result.timezone == "Europe/London")
        #expect(result.days.count == 2)
        
        let firstDay = try #require(result.days.first)
        
        #expect(firstDay.id == "2026-10-07")
        #expect(firstDay.weatherCode == 1)
        #expect(firstDay.maximumTemperature == 22)
        #expect(firstDay.minimumTemperature == 14)
        #expect(firstDay.precipitationProbability == 10)
        #expect(firstDay.precipitation == 0)
        #expect(firstDay.snowfall == 0)
        #expect(firstDay.windSpeed == 15)
        #expect(firstDay.sunshineDuration == 25_000)
        #expect(firstDay.uvIndex == 5)
    }
    
    @Test
    func fetchForecastThrowsForMismatchedArrayLengths() async {
        let apiClient = MockAPIClient()
        
        apiClient.response = ForecastResponseDTO(latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London", daily: DailyForecastDTO(time: ["2026-10-07", "2026-10-08"], weatherCode: [1], temperatureMax: [22, 20], temperatureMin: [14, 12], precipitationProbabilityMax: [10, 20], precipitationSum: [0, 1], snowfallSum: [0, 0], windSpeedMax: [15, 20], sunshineDuration: [25_000, 20_000], uvIndexMax: [5, 4])
        )
        
        let sut = OpenMeteoWeatherRepository(apiClient: apiClient)
        
        await #expect(throws: APIError.decodingFailed) {
            try await sut.fetchForecast(latitude: 51.5074, longitude: -0.1278)
        }
    }
    
    @Test
    func fetchForecastPropagatesAPIError() async {
        let apiClient = MockAPIClient()
        apiClient.error = APIError.networkUnavailable
        
        let sut = OpenMeteoWeatherRepository(apiClient: apiClient)
        
        await #expect(throws: APIError.networkUnavailable) {
            try await sut.fetchForecast(latitude: 51.5074, longitude: -0.1278)
        }
    }
    
    private func makeForecastResponse() -> ForecastResponseDTO {
        ForecastResponseDTO(latitude: 51.5074, longitude: -0.1278, timezone: "Europe/London", daily: DailyForecastDTO(     time: ["2026-10-07", "2026-10-08"], weatherCode: [1, 2], temperatureMax: [22, 20], temperatureMin: [14, 12], precipitationProbabilityMax: [10, 20], precipitationSum: [0, 1], snowfallSum: [0, 0], windSpeedMax: [15, 20], sunshineDuration: [25_000, 20_000], uvIndexMax: [5, 4])
        )
    }
}
