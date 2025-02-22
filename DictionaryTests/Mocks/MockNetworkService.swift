//
//  MockNetworkService.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import Foundation
@testable import Dictionary

final class MockNetworkService: NetworkServiceProtocol {
    var mockDefinition: WordDefinitionResponse?
    var mockError: Error?
    var shouldFail = false
    var fetchCount = 0
    
    func fetchWordDefinition(word: String) async throws -> WordDefinitionResponse {
        fetchCount += 1
        if shouldFail {
            throw mockError ?? NetworkError.serverError(500)
        }
        if let definition = mockDefinition {
            return definition
        }
        throw NetworkError.noData
    }
}
