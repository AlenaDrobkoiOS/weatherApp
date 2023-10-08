//
//  CoreDataService.swift
//  Tertill
//
//  Created by Alena Drobko on 22.10.2020.
//  Copyright © 2020 PulseCaster, Inc. All rights reserved.
//

import CoreData
import Foundation

class CoreDataHelper<T: NSManagedObject> {
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addRecord(_ type: T.Type) -> T? {
        let entityName = type.description().replacingOccurrences(of: "Tertill.", with: "")
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        if let uEntity = entity {
            let record = T(entity: uEntity, insertInto: context)
            return record
        }
        
        return nil
    }
    
    func recordsInTable(_ type: T.Type) -> Int {
        let recs = allRecords(T.self)
        return recs.count
    }
    
    func allRecords(_ type: T.Type, sort: NSSortDescriptor? = nil) -> [T] {
        let request = T.fetchRequest()
        do {
            let results = try context.fetch(request)
            if  let result = results as? [T] {
                return result
            }
            return []
        } catch {
            print("Error with request: \(error)")
            return []
        }
    }
    
    func query(_ type: T.Type, search: NSPredicate?, sort: NSSortDescriptor? = nil,
               multiSort: [NSSortDescriptor]? = nil) -> [T] {
        let request = type.fetchRequest()
        if let predicate = search {
            request.predicate = predicate
        }
        
        if let sortDescriptors = multiSort {
            request.sortDescriptors = sortDescriptors
        } else if let sortDescriptor = sort {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            let results = try context.fetch(request)
            if  let result = results as? [T] {
                return result
            }
            return []
        } catch {
            print("Error with request: \(error)")
            return []
        }
    }
    
    func deleteRecord(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    func deleteRecords(_ type: T.Type, search: NSPredicate? = nil) {
        let request = T.fetchRequest()
        if let predicate = search {
            request.predicate = predicate
        }
        let deleteBatchRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteBatchRequest)
        } catch {
            print(error)
        }
    }
    
    func saveDatabase() {
        do {
            try context.save()
            print("Save \(String(describing: T.self)) changes")
            let parent = context.parent
            parent?.performAndWait {
                do {
                    try parent?.save()
                } catch {
                    print("Error saving database: \(error)")
                }
            }
        } catch {
            print("Error saving database: \(error)")
        }
    }
}
