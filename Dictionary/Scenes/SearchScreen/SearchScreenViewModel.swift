//
//  WordDefinitionViewModel.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import Foundation
import CoreData
import SwiftUI

/// View model that manages the dictionary word search and results
@MainActor
class SearchScreenViewModel: ObservableObject {
    /// The current search term entered by the user
    @Published var searchTerm = ""
    
    /// The current word definition being displayed
    @Published var definition: WordDefinitionResponse?
    
    /// Indicates whether a network request is in progress
    @Published var isLoading = false
    
    /// Current error message to display, if any
    @Published var error: String?
    
    /// List of recently searched words
    @Published var recentSearches: [String] = []
    
    private let networkService: NetworkServiceProtocol
    private let viewContext: NSManagedObjectContext
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.networkService = networkService
        self.viewContext = viewContext
        loadRecentSearches()
    }
    
    /// Clears the current search and resets the view state
    func clearSearch() {
        searchTerm = ""
        definition = nil
        error = nil
    }
    
    /// Searches for the definition of the current search term
    func searchWord() {
        guard !searchTerm.isEmpty else { return }
        
        Task {
            isLoading = true
            error = nil
            
            if let cachedDefinition = await fetchFromCache(word: searchTerm) {
                self.definition = cachedDefinition
                self.isLoading = false
                return
            }
            
            do {
                let definition = try await networkService.fetchWordDefinition(word: searchTerm)
                self.definition = definition
                await saveToCache(definition: definition)
                await addToRecentSearches(word: definition.word)
            } catch {
                self.error = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    /// Fetches a word definition from the local cache
    private func fetchFromCache(word: String) async -> WordDefinitionResponse? {
        let request = NSFetchRequest<CachedWordDefinition>(entityName: "CachedWordDefinition")
        request.predicate = NSPredicate(format: "word == %@", word.lowercased())
        
        do {
            if let cached = try viewContext.fetch(request).first,
               let data = cached.jsonData {
                return try JSONDecoder().decode(WordDefinitionResponse.self, from: data)
            }
        } catch {
            print("Cache fetch error: \(error)")
        }
        return nil
    }
    
    /// Saves a word definition to the local cache
    private func saveToCache(definition: WordDefinitionResponse) async {
        await viewContext.perform {
            let cached = CachedWordDefinition(context: self.viewContext)
            cached.word = definition.word.lowercased()
            cached.timestamp = Date()
            
            do {
                let encoder = JSONEncoder()
                cached.jsonData = try encoder.encode(definition)
                try self.viewContext.save()
            } catch {
                print("Cache save error: \(error)")
            }
        }
    }
    
    /// Loads the list of recent searches from CoreData
    private func loadRecentSearches() {
        let request = NSFetchRequest<CachedWordDefinition>(entityName: "CachedWordDefinition")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CachedWordDefinition.timestamp, ascending: false)]
        
        do {
            let cached = try viewContext.fetch(request)
            recentSearches = cached.compactMap { $0.word }
        } catch {
            print("Recent searches fetch error: \(error)")
        }
    }
    
    /// Adds a word to the recent searches list
    private func addToRecentSearches(word: String) async {
        if !recentSearches.contains(word.lowercased()) {
            recentSearches.insert(word.lowercased(), at: 0)
            if recentSearches.count > 10 {
                recentSearches.removeLast()
            }
        }
    }
}
