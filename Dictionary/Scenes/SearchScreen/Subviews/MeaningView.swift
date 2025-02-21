//
//  MeaningView.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import SwiftUI

struct MeaningView: View {
    let meaning: WordDefinitionResponse.Meaning
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(meaning.partOfSpeech)
                .font(.headline)
                .foregroundColor(.blue)
            
            ForEach(meaning.definitions.indices, id: \.self) { index in
                let definition = meaning.definitions[index]
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(index + 1). \(definition.definition)")
                    
                    if let example = definition.example {
                        Text("Example: \(example)")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    }
                }
            }
        }
    }
}
