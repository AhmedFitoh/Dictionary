//
//  NetworkError.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import Foundation

/// Represents possible network-related errors in the application
enum NetworkError: LocalizedError {
    /// Invalid URL format
    case invalidURL
    
    /// No internet connection available
    case noInternetConnection
    
    /// Requested word not found in dictionary
    case notFound
    
    /// Server error with status code
    case serverError(Int)
    
    /// Error decoding the response
    case decodingError
    
    /// No data received in response
    case noData
    
    /// Too many requests made to the API
    case rateLimitExceeded
    
    /// Request timed out
    case timeout
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "Invalid URL format"
            case .noInternetConnection:
                return "No internet connection. Please check your connection and try again"
            case .notFound:
                return "Word not found in dictionary"
            case .serverError(let code):
                return "Server error occurred (Error \(code)). Please try again later"
            case .decodingError:
                return "Error processing server response"
            case .noData:
                return "No definition found"
            case .rateLimitExceeded:
                return "Too many requests. Please try again in a moment"
            case .timeout:
                return "Request timed out. Please try again"
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noInternetConnection, .noInternetConnection),
             (.notFound, .notFound),
             (.decodingError, .decodingError),
             (.noData, .noData),
             (.rateLimitExceeded, .rateLimitExceeded),
             (.timeout, .timeout):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
