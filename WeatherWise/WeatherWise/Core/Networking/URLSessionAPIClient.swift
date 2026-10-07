//
//  URLSessionAPIClient.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

struct URLSessionAPIClient: APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T {
        
        guard let url = endpoint.url else { throw APIError.invalidURL }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.httpStatus(httpResponse.statusCode)
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
                
            } catch {
                throw APIError.decodingFailed
            }
        } catch let error as APIError {
            throw error
            
        } catch is URLError {
            throw APIError.networkUnavailable
            
        } catch {
            throw APIError.requestFailed
        }
    }
}
