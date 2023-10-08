//
//  ManagedObject.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import CoreData
import Foundation

extension NSManagedObject {
    
    static var defaultContext: NSManagedObjectContext?
    
    public static func entityName() -> String {
        var name = NSStringFromClass(self)
        if name.range(of: ".") != nil {
            
            let comp = name.split {$0 == "."}.map { String($0) }
            if comp.count > 1 {
                name = comp.last!
            }
        }
        if name.range(of: "_") != nil {
            var comp = name.split {$0 == "_"}.map { String($0) }
            var last: String = ""
            var remove = -1
            for (index, symbol) in comp.reversed().enumerated() {
                if last == symbol {
                    remove = index
                }
                last = symbol
            }
            if remove > -1 {
                comp.remove(at: remove)
                name = comp.joined(separator: "_")
            }
        }
        return name
    }
    
    static func createEntityInContext(plain: ManagedObjectConvertible, context: NSManagedObjectContext) -> NSManagedObject? {
        let entity = NSEntityDescription.entity(forEntityName: self.description(), in: context)

        guard let uEntity = entity else {
            return nil
        }
        
        let object = self.init(entity: uEntity, insertInto: context)
        return  plain.toManagedObject(object: object)
    }
    
    func updateRelationShips(entities: [ManagedObjectConvertible]) throws {
        guard let context = NSManagedObject.defaultContext else { return }
        try self.updateRelationShipsInContext(context: context, entities: entities)
    }
    
    func updateRelationShipsInContext(context: NSManagedObjectContext, entities: [ManagedObjectConvertible]) throws {
        
        guard let convertible = entities.first else {
            return
        }
        
        let entityType = convertible.entityType()
        let entityName = entityType.description()
        
        guard let relationShipEntity = NSEntityDescription.entity(forEntityName: entityName,
                                                                  in: context) else {
            return
        }
        
        guard let key = self.nameForRelationShipProperty(relationShipEntity: relationShipEntity) else {
            return
        }
        
        let addSelectorString = "add\(key.capitalized):"
        let removeSelectorString = "remove\(key.capitalized):"
        
        let oldRelationShips = self.value(forKey: key) as? NSSet
        var currentRelationships = [NSManagedObject]()
        var newRelationships = [NSManagedObject]()
        
        let addSelector = Selector(addSelectorString)
        if oldRelationShips == nil || oldRelationShips?.count == 0 {
            let relationships = entities.compactMap { entityType.createEntityInContext(plain: $0, context: context) }
            let newRelationships = NSSet(array: relationships)
            if self.responds(to: addSelector) {
                self.perform(addSelector, with: newRelationships)
                return
            }
        }
        
        for entity in entities {
            if let predicate = entity.predicate {
                if let filtered = oldRelationShips?.filtered(using: predicate) as? Set<NSManagedObject>, filtered.count != 0 {
                    let filteredArray = Array(filtered)
                    if let entityToUpdate = filteredArray.first {
                        if let updated = entity.toManagedObject(object: entityToUpdate) {
                            currentRelationships.append(updated)
                        }
                    }
                } else {
                    if let new = entityType.createEntityInContext(plain: entity, context: context) {
                        newRelationships.append(new)
                    }
                }
            }
        }
        
        guard let oldSet = oldRelationShips as? Set<NSManagedObject> else {
            return
        }
        
        let newSet = Set(newRelationships)
        if newRelationships.isEmpty == false {
            if self.responds(to: addSelector) {
                self.perform(addSelector, with: newSet)
            }
        }
        
        let currentSet = Set(currentRelationships)
        
        let removed = Array(oldSet.subtracting(currentSet))
        let removedSet = NSSet(array: removed)
        let removeSelector = Selector(removeSelectorString)
        if removed.isEmpty != true {
            if self.responds(to: removeSelector) {
                self.perform(removeSelector, with: removedSet)
                return
            }
        }
        
        try context.save()
        print("\(String(describing: oldRelationShips))")
        
    }
    
    func nameForRelationShipProperty(relationShipEntity: NSEntityDescription) -> String? {
        for property in self.entity.properties {
            let propertyName = property.name
            if let relationships = self.entity.relationshipsByName[propertyName] {
                let destination = relationships.destinationEntity
                let isEntity = destination?.isKindOf(entity: relationShipEntity) ?? false
                if isEntity == true {
                   return propertyName
                }
            }
        }
        
        return nil
    }
    
    class func findAll(context: NSManagedObjectContext) -> [NSManagedObject] {
        let request = self.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results as? [NSManagedObject] ?? []
        } catch {
            print("Error with request: \(error)")
            return []
        }
    }
    
    class func findByPredicate(context: NSManagedObjectContext,
                               predicate: NSPredicate,
                               sort: NSSortDescriptor? = nil,
                               fetchLimit: Int? = nil,
                               multiSort: [NSSortDescriptor]? = nil) -> [NSManagedObject] {
        let request = self.fetchRequest()
        request.predicate = predicate
        
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        
        if let sortDescriptors = multiSort {
            request.sortDescriptors = sortDescriptors
        } else if let sortDescriptor = sort {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            let results = try context.fetch(request)
            return results as? [NSManagedObject] ?? []
        } catch {
            print("Error with request: \(error)")
            return []
        }
    }
    
    func deleteEntityInContext(context: NSManagedObjectContext) throws {
        let entityInContext = try context.existingObject(with: self.objectID)
        context.delete(entityInContext)
    }
}
