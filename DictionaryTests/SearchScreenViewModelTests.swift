//
//  SearchScreenViewModelTests.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//


import XCTest
import CoreData
@testable import Dictionary

@MainActor
class SearchScreenViewModelTests: XCTestCase {
    var viewModel: SearchScreenViewModel!
    var mockNetworkService: MockNetworkService!
    var mockViewContext: NSManagedObjectContext!
    
    override func setUp() async throws {
        try await super.setUp()
        mockNetworkService = MockNetworkService()
        
        // Set up in-memory Core Data stack for testing
        let container = NSPersistentContainer(name: "Dictionary")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        await withCheckedContinuation { continuation in
            container.loadPersistentStores { _, error in
                XCTAssertNil(error)
                continuation.resume()
            }
        }
        
        mockViewContext = container.viewContext
        
        await MainActor.run {
            viewModel = SearchScreenViewModel(
                networkService: mockNetworkService,
                viewContext: mockViewContext
            )
        }
    }
    
    override func tearDown() async throws {
        await MainActor.run {
            viewModel = nil
        }
        mockNetworkService = nil
        mockViewContext = nil
        try await super.tearDown()
    }
    
    @MainActor
    func testSearchWord_Success() async throws {
        // Given
        let expectedWord = "test"
        let expectedDefinition = WordDefinitionResponse(
            word: expectedWord,
            phonetic: "/test/",
            phonetics: [],
            meanings: [
                WordDefinitionResponse.Meaning(
                    partOfSpeech: "noun",
                    definitions: [
                        WordDefinitionResponse.Meaning.Definition(
                            definition: "A procedure for testing something",
                            example: "Run a test",
                            synonyms: nil,
                            antonyms: nil
                        )
                    ]
                )
            ]
        )
        mockNetworkService.mockDefinition = expectedDefinition
        mockNetworkService.shouldFail = false
        
        // When
        viewModel.searchTerm = expectedWord
        viewModel.searchWord()
        
        // Then
        // Add delay to allow async operations to complete
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second delay
        
        // Verify network service was called
        XCTAssertEqual(mockNetworkService.fetchCount, 1, "Network service should be called once")
        
        // Verify the results
        XCTAssertNotNil(viewModel.definition, "Definition should not be nil after successful search")
        XCTAssertEqual(viewModel.definition?.word, expectedWord, "Word should match expected word")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after search completes")
        XCTAssertNil(viewModel.error, "Error should be nil after successful search")
        XCTAssertTrue(viewModel.recentSearches.contains(expectedWord), "Recent searches should contain the searched word")
    }
    
    @MainActor
    func testSearchWord_EmptyTerm() async throws {
        // When
        viewModel.searchTerm = ""
        viewModel.searchWord()
        
        // Add delay to allow async operations to complete
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second delay

        // Then
        XCTAssertNil(viewModel.definition)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testSearchWord_NetworkError() async throws {
        // Given
        mockNetworkService.shouldFail = true
        mockNetworkService.mockError = NetworkError.noInternetConnection
        
        // When
        viewModel.searchTerm = "test"
        viewModel.searchWord()
        
        // Then
        // Add delay to allow async operations to complete
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second delay
        
        XCTAssertNil(viewModel.definition, "Definition should be nil on error")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after error")
        XCTAssertNotNil(viewModel.error, "Error should not be nil")
        XCTAssertEqual(viewModel.error, NetworkError.noInternetConnection.errorDescription, "Error message should match network error description")
    }
    
    @MainActor
    func testClearSearch() {
        // Given
        viewModel.searchTerm = "test"
        viewModel.definition = WordDefinitionResponse(word: "test", phonetic: nil, phonetics: [], meanings: [])
        viewModel.error = "Some error"
        
        // When
        viewModel.clearSearch()
        
        // Then
        XCTAssertTrue(viewModel.searchTerm.isEmpty)
        XCTAssertNil(viewModel.definition)
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testCacheOperation() async throws {
        // Given
        let testWord = "cache"
        let testDefinition = WordDefinitionResponse(
            word: testWord,
            phonetic: "/cache/",
            phonetics: [],
            meanings: [
                WordDefinitionResponse.Meaning(
                    partOfSpeech: "noun",
                    definitions: [
                        WordDefinitionResponse.Meaning.Definition(
                            definition: "A collection of items of the same type stored in a hidden or inaccessible place.",
                            example: nil,
                            synonyms: nil,
                            antonyms: nil
                        )
                    ]
                )
            ]
        )
        mockNetworkService.mockDefinition = testDefinition
        
        // When - First search (should cache)
        viewModel.searchTerm = testWord
        viewModel.searchWord()
        
        // Then - Verify first search result
        // Add delay to allow async operations to complete
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second delay
        
        XCTAssertNotNil(viewModel.definition, "Definition should not be nil after first search")
        XCTAssertEqual(viewModel.definition?.word, testWord, "Word should match test word after first search")
        
        // When - Clear and search again (should use cache)
        viewModel.clearSearch()
        mockNetworkService.mockDefinition = nil // Remove mock to ensure cache is used
        viewModel.searchTerm = testWord
        viewModel.searchWord()
        // Add delay to allow async operations to complete
        try await Task.sleep(nanoseconds: 1_000_000_000)  // 1 second delay
        
        // Then - Verify cached result
        XCTAssertNotNil(viewModel.definition, "Definition should not be nil when retrieved from cache")
        XCTAssertEqual(viewModel.definition?.word, testWord, "Word should match test word when retrieved from cache")
        
        // Verify network service wasn't called for second search
        XCTAssertTrue(mockNetworkService.mockDefinition == nil, "Network service should not be used for cached word")
    }
}
