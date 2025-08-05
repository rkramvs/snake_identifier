//
//  Persistence.swift
//  snake identifier
//
//  Created by Ram Kumar on 31/07/25.
//

import CoreData

class PersistenceController {

    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        
        let storeURL = URL.storeURL(for: AppConstants.appGroup, databaseName: "snake_identifier")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container = NSPersistentContainer(name: "snake_identifier")
        container.persistentStoreDescriptions = [storeDescription]
    
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        try? container.viewContext.setQueryGenerationFrom(.current)

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFromRemoteChanges), name: .NSPersistentStoreRemoteChange, object: nil)
    }
    
    @objc func fetchFromRemoteChanges() {
        container.viewContext.perform {
          self.container.viewContext.refreshAllObjects()
        }
    }
 
    @discardableResult
    func saveContext() -> Error? {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return nil
            } catch {
                let nserror = error as NSError
                print(nserror.localizedDescription)
                return error
            }
        }
        return nil
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}


