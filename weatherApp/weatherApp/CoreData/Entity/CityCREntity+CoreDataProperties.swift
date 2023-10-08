//
//  CityCREntity+CoreDataProperties.swift
//  
//
//  Created by Alena Drobko on 08.10.23.
//
//

import Foundation
import CoreData

extension CityCREntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityCREntity> {
        return NSFetchRequest<CityCREntity>(entityName: "CityCREntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var history: Set<WeatherInfoCREntity>?

}

// MARK: Generated accessors for history
extension CityCREntity {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: WeatherInfoCREntity)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: WeatherInfoCREntity)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}

extension CityCREntity: Identifiable { }
