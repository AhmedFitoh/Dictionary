# Dictionary App

A modern iOS dictionary application built with SwiftUI that allows users to look up word definitions, view phonetic pronunciations, and manage search history.

## Features

- Search for word definitions using the Free Dictionary API
- View detailed word information including:
  - Phonetic pronunciation
  - Multiple meanings and definitions
  - Usage examples
  - Parts of speech
- Offline support with local caching of searched words
- Recent searches history
- Error handling with user-friendly error messages
- Clean and intuitive user interface

## Technical Overview

### Architecture
- MVVM (Model-View-ViewModel) architecture
- SwiftUI for the user interface
- CoreData for local persistence
- Async/await for network operations
- Protocol-oriented networking layer

### Key Components

### Dependencies
- Uses the free Dictionary API (api.dictionaryapi.dev)
- No external dependencies required

## API Integration

The app integrates with the Free Dictionary API:
```
Base URL: https://api.dictionaryapi.dev/api/v2/entries/en/
```

## Data Persistence

The app uses CoreData for:
- Caching word definitions
- Storing recent searches
- Offline access to previously searched words

## Error Handling

Comprehensive error handling for:
- Network connectivity issues
- Invalid searches
- API rate limiting
- Server errors
- Data parsing issues

## Requirements

- iOS 18.0+
- Xcode 16.1+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open Dictionary.xcodeproj in Xcode
3. Build and run the project

## License
This project is licensed under the MIT License - see the LICENSE file for details
