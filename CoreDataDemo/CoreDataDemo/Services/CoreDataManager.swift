//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by Nikolai Maksimov on 24.01.2024.
//

import UIKit
import CoreData


final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // MARK: Private properties
    private let viewContext: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "CoreDataDemo")
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
           if let error = error as NSError? {
               fatalError("Unresolved error \(error), \(error.userInfo)")
           }
       })
       return container
   }()
    
    // MARK: Private Init
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: Core Data Saving support
    private func saveContext () {
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

// MARK: - CRUD
extension CoreDataManager {
    
}
