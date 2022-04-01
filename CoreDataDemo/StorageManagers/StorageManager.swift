//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Юрий Скворцов on 01.04.2022.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private let context: NSManagedObjectContext
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    //MARK: Public methods
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, _ changedTask: String) {
        task.title = changedTask
        saveContext()
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest
        
        do {
            let tasks = try context.fetch(fetchRequest())
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
}
