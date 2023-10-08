//
//  ManagedObjectConvertible.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import CoreData
import Foundation

/// Protocol for PlainObject
protocol ManagedObjectConvertible {
    /// Predicate for search
    var predicate: NSPredicate? { get }
    
    /// Return type to which it can convert
    func entityType() -> NSManagedObject.Type
    /// Convert to NSManagedObject
    func toManagedObject(object: NSManagedObject) -> NSManagedObject?
}
