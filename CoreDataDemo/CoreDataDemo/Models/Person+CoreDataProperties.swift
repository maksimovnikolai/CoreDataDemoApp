//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Nikolai Maksimov on 24.01.2024.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var cars: Car?

}

extension Person : Identifiable {

}
