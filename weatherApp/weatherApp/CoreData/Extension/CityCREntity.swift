//
//  CityCREntity.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.23.
//

import CoreData
import Foundation

extension CityCREntity: PlainObjectConvertible {
    typealias PlainObject = CityInfo
    
    func toPlainObject() -> CityInfo {
        let city = City(id: Int(self.id),
                        name: self.name ?? "n/a",
                        country: self.country ?? "n/a")
        let history = self.history?.map({ $0.toPlainObject() })
        
        return CityInfo(city: city, history: history ?? [HistoricalInfo]())
    }
}

extension CityInfo: ManagedObjectConvertible {
    var predicate: NSPredicate? {
        return NSPredicate(format: "id == %lu", city.id)
    }
    
    func entityType() -> NSManagedObject.Type {
        return CityCREntity.self
    }
    
    func toManagedObject(object: NSManagedObject) -> NSManagedObject? {
        let cityEntity = object as? CityCREntity
        cityEntity?.id = Int64(city.id)
        cityEntity?.name = city.name
        cityEntity?.country = city.country
        return cityEntity
    }
}
