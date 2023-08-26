//
//  StorageManager.swift
//  TaskListCoreData
//
//  Created by Кирилл on 20.08.2023.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    //MARK: - Core Data stack
    
    private let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TaskListCoreData")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viweContext: NSManagedObjectContext
    
    private init() {
        viweContext = persistentContainer.viewContext
    }
    
    //MARK: - CRUD
    
    func create(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viweContext)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viweContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viweContext.delete(task)
        saveContext()
    }
    
    //MARK: - Core Data Saving support
    
    func saveContext () {
        if viweContext.hasChanges {
            do {
                try viweContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

