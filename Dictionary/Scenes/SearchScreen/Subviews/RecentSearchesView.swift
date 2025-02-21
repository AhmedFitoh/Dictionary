//
//  RecentSearchesView.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import SwiftUI

struct RecentSearchesView: View {
    let searches: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            if !searches.isEmpty {
                Text("Recent Searches")
                    .font(.headline)
                    .padding(.horizontal)
                
                List(searches, id: \.self) { word in
                    Button(action: { onSelect(word) }) {
                        Text(word)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Recent Searches",
                    systemImage: "magnifyingglass",
                    description: Text("Search for a word to see its definition")
                )
            }
        }
    }
}
