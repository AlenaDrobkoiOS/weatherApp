//
//  GenericDAO.swift
//  iOS_Core
//
//  Created by Alena Drobko on 05.03.2021.
//  Copyright © 2021 PulseCaster, Inc. All rights reserved.
//

import CoreData
import Foundation

/// Generic DataAccessObject
class GenericDAO<T: ManagedObjectConvertible, M: NSManagedObject>: DataAccessObject where M: PlainObjectConvertible, T: Equatable {
    
    typealias DataObjectType = T
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Create NSManagedObject
    func createManagedObject(_ plain: T) -> NSManagedObject? {
        return M.createEntityInContext(plain: plain, context: context)
    }
    
    /// Create NSManagedObject from PlainObject and return completion after finish
    func create(_ plain: T, completion: EmptyClosureType?) {
        _ = createManagedObject(plain)
        completion?()
    }
    
    /// Create array of NSManagedObject from array of PlainObject and return completion after finish
    func create(_ plains: [T], completion: EmptyClosureType?) {
        for plain in plains {
            _ = createManagedObject(plain)
        }
        completion?()
    }
    
    /// Update NSManagedObject from PlainObject and return completion after finish
    func update(_ plain: T, completion: EmptyClosureType?) {
        guard let predicate = plain.predicate else { return }
        
        self.get(predicate) { records in
            guard let record = records?.first as? M else { return }
            _ = plain.toManagedObject(object: record)
            completion?()
        }
    }
    
    /// Update array of NSManagedObject from array of PlainObject and return completion after finish
    func update(_ plains: [T], completion: EmptyClosureType?) {
        for plain in plains {
            update(plain, completion: nil)
        }
        completion?()
    }
    
    /// Check entity and return completion with result
    func entityExists(_ entity: T, _ completion: SimpleClosure<Bool>?) {
        self.getAll { entities in
            let exists = entities?.contains(where: { $0 == entity }) ?? false
            completion?(exists)
        }
    }
    
    /// Search by predicate and return completion with array of ManagedObject
    func get(_ predicate: NSPredicate, completion: SimpleClosure<[M]?>?) {
        if let records = M.findByPredicate(context: context, predicate: predicate) as? [M] {
            completion?(records)
        } else {
            completion?(nil)
        }
    }
    
    /// Search by  properties and values, return completion with array of ManagedObject
    func get(_ properties: [String], _ values: [String], completion: SimpleClosure<[M]?>?) {
        let predicate = self.buildAndPredicate(properties, values)
        self.get(predicate, completion: completion)
    }
    
    /// Search by predicate and return completion with array of PlainObject
    func get(_ predicate: NSPredicate, _ sort: NSSortDescriptor?, _ fetchLimit: Int?,
             completion: SimpleClosure<[T]?>?) {
        if let records = M.findByPredicate(context: context, predicate: predicate, sort: sort,
                                           fetchLimit: fetchLimit) as? [M] {
            let entities = records.map { record -> M.PlainObject in
                return record.toPlainObject()
            }
            completion?(entities as? [T])
        }
    }
    
    /// Get all objects  and return completion with array of PlainObject
    func getAll(completion: SimpleClosure<[T]?>?) {
        if let records = M.findAll(context: context) as? [M] {
            let entities = records.map { record -> M.PlainObject in
                return record.toPlainObject()
            }
            completion?(entities as? [T])
        }
    }
    
    /// Search by  properties and values, and delete result
    func delete(_ properties: [String], _ values: [String]) {
        get(properties, values) { records in
            if let record = records?.first as? M {
                self.context.delete(record)
            }
        }
    }
    
    /// Delete all
    func deleteAll() {
        M.findAll(context: context).forEach({ record in
            try? record.deleteEntityInContext(context: context)
        })
    }
    
    /// Save to database
    func save() {
        try? self.context.save()
    }
}
