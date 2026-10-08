//
//  OpenMeteoWeatherRepository.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct OpenMeteoWeatherRepository: WeatherRepository {
    private let apiClient: any APIClient
    private let cache: any WeatherCache
    
    init(apiClient: any APIClient, cache: any WeatherCache) {
        self.apiClient = apiClient
        self.cache = cache
    }
    
    func fetchForecast(latitude: Double, longitude: Double) async throws -> WeatherForecast {
        
        let endpoint = APIEndpoint.forecast(latitude: latitude, longitude: longitude)
        
        do {
            let response: ForecastResponseDTO = try await apiClient.request(endpoint)
            let forecast = try mapToDomain(response)
            cache.save(forecast, latitude: latitude, longitude: longitude)
            return forecast
            
        } catch {
            if let cachedForecast = cache.load(latitude: latitude, longitude: longitude) {
                return cachedForecast
            }

            throw error
        }
    }
    
    private func mapToDomain(_ response: ForecastResponseDTO) throws -> WeatherForecast {
        let daily = response.daily
        let count = daily.time.count
        
        guard
            daily.weatherCode.count == count,
            daily.temperatureMax.count == count,
            daily.temperatureMin.count == count,
            daily.precipitationProbabilityMax.count == count,
            daily.precipitationSum.count == count,
            daily.snowfallSum.count == count,
            daily.windSpeedMax.count == count,
            daily.sunshineDuration.count == count,
            daily.uvIndexMax.count == count
        else {
            throw APIError.decodingFailed
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var days: [WeatherDay] = []
        days.reserveCapacity(count)
        
        for index in 0..<count {
            let dateString = daily.time[index]
            
            guard let date = dateFormatter.date(from: dateString) else {
                throw APIError.decodingFailed
            }
            
            let day = WeatherDay(id: dateString, date: date, weatherCode: daily.weatherCode[index], maximumTemperature: daily.temperatureMax[index], minimumTemperature: daily.temperatureMin[index], precipitationProbability: daily.precipitationProbabilityMax[index], precipitation: daily.precipitationSum[index], snowfall: daily.snowfallSum[index], windSpeed: daily.windSpeedMax[index], sunshineDuration: daily.sunshineDuration[index], uvIndex: daily.uvIndexMax[index])
            
            days.append(day)
        }
        
        return WeatherForecast(latitude: response.latitude, longitude: response.longitude, timezone: response.timezone, days: days)
    }
}
