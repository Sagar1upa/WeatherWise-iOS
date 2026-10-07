//
//  AppError.swift
//  WeatherWise
//
//  Created by Sagar Upadhyay on 07/10/26.
//

import Foundation

enum AppError: Error, Equatable, Sendable {
    case invalidURL
    case networkUnavailable
    case server(Int)
    case decoding
    case requestFailed
    case unknown
    
    var message: String {
        switch self {
        case .invalidURL:
            return "The request could not be created."
            
        case .networkUnavailable:
            return "Please check your internet connection and try again."
            
        case let .server(statusCode):
            return "The server returned an error (\(statusCode))."
            
        case .decoding:
            return "The weather data could not be processed."
            
        case .requestFailed:
            return "Something went wrong. Please try again."
            
        case .unknown:
            return "Something unexpected happened. Please try again."
        }
    }
    
    init(error: Error) {
        
        if let appError = error as? AppError {
            self = appError
            return
        }
        
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                self = .invalidURL
                
            case .networkUnavailable:
                self = .networkUnavailable
                
            case let .httpStatus(statusCode):
                self = .server(statusCode)
                
            case .decodingFailed:
                self = .decoding
                
            case .invalidResponse, .requestFailed:
                self = .requestFailed
            }
            
            return
        }
        
        self = .unknown
    }
}
