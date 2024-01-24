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
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    private var persons: [Person] = []
    private var cars: [Car] = []

    // MARK: Private Init
    private init() {
        viewContext = persistentContainer.viewContext
    }
    


}

// MARK: - Person - CRUD
extension CoreDataManager {
    
    // MARK: Create
    func createPerson(name: String) -> Person {
        let person =  Person(entity: Person.entity(), insertInto: viewContext)
        person.name = name
        do {
            try viewContext.save()
        } catch {
            print("error saving")
        }
        return person
    }
    
    
    // MARK: Fetch
    func fetchPersons() -> [Person] {
        do {
            persons = try viewContext.fetch(Person.fetchRequest())
        } catch {
            print("error")
        }
        return persons
    }
    
    // MARK: Update
    func update() {
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    // MARK: Delete
    func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: Core Data Saving support
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

// MARK: - Car - CRUD
private extension CoreDataManager {
    
}
