//
//  NetworkServiceProtocol.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import Foundation

/// Protocol defining the network service interface for dictionary operations
protocol NetworkServiceProtocol {
    /// Fetches the definition for a given word
    /// - Parameter word: The word to look up
    /// - Returns: A word definition response
    /// - Throws: NetworkError if the request fails
    func fetchWordDefinition(word: String) async throws -> WordDefinitionResponse
}

import Foundation

/// Actor responsible for making network requests to the dictionary API
actor NetworkService: NetworkServiceProtocol {
    /// Base URL for the dictionary API
    private let baseURL = "https://api.dictionaryapi.dev/api/v2/entries/en/"
    
    /// Timeout interval for requests in seconds
    private let timeoutInterval: TimeInterval = 15
    
    func fetchWordDefinition(word: String) async throws -> WordDefinitionResponse {
        guard let url = URL(string: baseURL + word.lowercased()) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError(0)
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    let definitions = try decoder.decode([WordDefinitionResponse].self, from: data)
                    guard let firstDefinition = definitions.first else {
                        throw NetworkError.noData
                    }
                    return firstDefinition
                } catch {
                    throw NetworkError.decodingError
                }
            case 404:
                throw NetworkError.notFound
            case 429:
                throw NetworkError.rateLimitExceeded
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode)
            default:
                throw NetworkError.serverError(httpResponse.statusCode)
            }
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.serverError(error._code)
            }
        } catch {
            throw error
        }
    }
}
