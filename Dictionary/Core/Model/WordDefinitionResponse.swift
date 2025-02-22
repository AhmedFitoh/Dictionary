//
//  WordDefinitionResponse.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/22/25.
//

import Foundation

/// Represents a word definition response from the dictionary API
struct WordDefinitionResponse: Codable {
    /// The word being defined
    let word: String
    
    /// The phonetic pronunciation of the word
    let phonetic: String?
    
    /// Array of phonetic representations including audio
    let phonetics: [Phonetic]
    
    /// Array of different meanings of the word
    let meanings: [Meaning]
    
    /// Represents phonetic information including pronunciation audio
    struct Phonetic: Codable {
        /// Written phonetic representation
        let text: String?
        
        /// URL to pronunciation audio file
        let audio: String?
    }
    
    /// Represents a specific meaning of the word
    struct Meaning: Codable {
        /// Part of speech (noun, verb, etc.)
        let partOfSpeech: String
        
        /// Array of definitions for this part of speech
        let definitions: [Definition]
        
        /// Represents a single definition with examples and related words
        struct Definition: Codable {
            /// The actual definition text
            let definition: String
            
            /// Optional usage example
            let example: String?
            
            /// Optional array of synonyms
            let synonyms: [String]?
            
            /// Optional array of antonyms
            let antonyms: [String]?
        }
    }
}
