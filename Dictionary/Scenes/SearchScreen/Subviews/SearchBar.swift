//
//  SearchBar.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    let onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search word", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .onSubmit(onSearch)
            
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding()
    }
}
