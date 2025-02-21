//
//  DictionaryApp.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/21/25.
//

import SwiftUI

@main
struct DictionaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
