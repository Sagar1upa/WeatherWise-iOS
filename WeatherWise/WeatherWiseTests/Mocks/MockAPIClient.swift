//
//  MockAPIClient.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation
@testable import WeatherWise

final class MockAPIClient: APIClient, @unchecked Sendable {
    var response: Any?
    var error: Error?
    var requestedEndpoint: APIEndpoint?

    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T {
        requestedEndpoint = endpoint

        if let error {
            throw error
        }

        guard let response = response as? T else {
            throw APIError.decodingFailed
        }

        return response
    }
}
