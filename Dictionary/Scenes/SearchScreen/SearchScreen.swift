//
//  SearchScreen.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/21/25.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject private var viewModel = SearchScreenViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $viewModel.searchTerm,
                         onSearch: viewModel.searchWord)
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(message: error) {
                        viewModel.searchWord()
                    }
                } else if let definition = viewModel.definition {
                    DefinitionView(definition: definition)
                        .overlay(alignment: .topTrailing) {
                            Button(action: viewModel.clearSearch) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            }
                            .padding()
                        }
                } else {
                    RecentSearchesView(searches: viewModel.recentSearches) { word in
                        viewModel.searchTerm = word
                        viewModel.searchWord()
                    }
                }
                Spacer()
            }
            .navigationTitle("Dictionary")
        }
    }
}
