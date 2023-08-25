//
//  StorageManager.swift
//  TaskListCoreData
//
//  Created by Кирилл on 20.08.2023.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TaskListCoreData")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

