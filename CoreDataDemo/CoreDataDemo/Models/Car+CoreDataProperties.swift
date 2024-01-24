//
//  Car+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Nikolai Maksimov on 24.01.2024.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var brand: String?
    @NSManaged public var person: Person?

}

extension Car : Identifiable {

}
