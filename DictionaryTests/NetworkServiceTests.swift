//
//  NetworkServiceTests.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import XCTest
@testable import Dictionary

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    
    override func setUp() {
        super.setUp()
        networkService = NetworkService()
    }
    
    override func tearDown() {
        networkService = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockResponse = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }
    
    func testFetchWordDefinition_Success() async throws {
        // Given
        let testWord = "test"
        let expectedDefinition = WordDefinitionResponse(
            word: testWord,
            phonetic: "/test/",
            phonetics: [],
            meanings: []
        )
        let jsonData = try JSONEncoder().encode([expectedDefinition])
        MockURLProtocol.mockData = jsonData
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/test")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result = try await networkService.fetchWordDefinition(word: testWord)
        
        // Then
        XCTAssertEqual(result.word, testWord)
    }
    
    func testFetchWordDefinition_NotFound() async {
        // Given
        let uuid = UUID().uuidString
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(uuid)")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        do {
            _ = try await networkService.fetchWordDefinition(word: uuid)
            XCTFail("Expected error not thrown")
        } catch let error as NetworkError {
            XCTAssertTrue(error == .notFound, "Expected .notFound error, got \(error)")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}


extension NetworkServiceTests {
    func makeURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
