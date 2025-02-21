//
//  DefinitionView.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import SwiftUI

struct DefinitionView: View {
    let definition: WordDefinitionResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(definition.word)
                    .font(.largeTitle)
                    .bold()
                
                if let phonetic = definition.phonetic {
                    Text(phonetic)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                ForEach(definition.meanings, id: \.partOfSpeech) { meaning in
                    MeaningView(meaning: meaning)
                }
            }
            .padding()
        }
    }
}
