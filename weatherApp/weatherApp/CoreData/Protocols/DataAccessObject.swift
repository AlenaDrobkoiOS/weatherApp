//
//  DataAccessObject.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import CoreData
import Foundation

/// () -> Void
typealias EmptyClosureType = () -> Void
/// (T) -> Void
typealias SimpleClosure<T> = (T) -> Void

/// Protocol for DataAccessObject
protocol DataAccessObject {
    
    associatedtype PlainObjectType
    associatedtype DataBaseObjectType: NSManagedObject
    
    /// Create NSManagedObject
    func createManagedObject(_ plain: PlainObjectType) -> NSManagedObject?
    /// Create NSManagedObject from PlainObject and return completion after finish
    func create(_ plain: PlainObjectType, completion: EmptyClosureType?)
    /// Create array of NSManagedObject from array of PlainObject and return completion after finish
    func create(_ plains: [PlainObjectType], completion: EmptyClosureType?)
    
    /// Update NSManagedObject from PlainObject and return completion after finish
    func update(_ plain: PlainObjectType, completion: EmptyClosureType?)
    /// Update array of NSManagedObject from array of PlainObject and return completion after finish
    func update(_ plains: [PlainObjectType], completion: EmptyClosureType?)
    
    /// Check entity and return completion with result
    func entityExists(_ plain: PlainObjectType, _ completion: SimpleClosure<Bool>?)
    
    /// Search by  properties and values, return completion with array of ManagedObject
    func get(_ properties: [String], _ values: [String], completion: SimpleClosure<[DataBaseObjectType]?>?)
    /// Search by predicate and return completion with array of ManagedObject
    func get(_ predicate: NSPredicate, completion: SimpleClosure<[DataBaseObjectType]?>?)
    /// Search by predicate and return completion with array of PlainObject
    func get(_ predicate: NSPredicate, _ sort: NSSortDescriptor?,
             _ fetchLimit: Int?, completion: SimpleClosure<[PlainObjectType]?>?)
    /// Get all objects  and return completion with array of PlainObject
    func getAll(completion: SimpleClosure<[PlainObjectType]?>?)
    
    /// Search by  properties and values, and delete result
    func delete(_ properties: [String], _ values: [String])
    /// Delete all
    func deleteAll()
    
    /// Save to database
    func save()
}

extension DataAccessObject {
    /// Create predicate 
    func buildAndPredicate(_ properties: [String], _ values: [String]) -> NSCompoundPredicate {
        var andPredicate: [NSPredicate] = []

        for (property, value) in zip(properties, values) {
            let predicate = NSPredicate(format: "ANY %K == [c] %@", property, value)
            andPredicate.append(predicate)
        }

        return NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
    }
}
