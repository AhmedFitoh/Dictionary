//
//  Persistence.swift
//  Dictionary
//
//  Created by AhmedFitoh on 2/21/25.
//

import CoreData

/// Manages CoreData persistence for the application
struct PersistenceController {
    /// Shared instance for app-wide use
    static let shared = PersistenceController()
    
    /// The CoreData container
    let container: NSPersistentContainer
    
    /// Initializes the persistence controller
    /// - Parameter inMemory: If true, uses an in-memory store
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dictionary")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
