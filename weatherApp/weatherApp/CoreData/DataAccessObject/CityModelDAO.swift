//
//  CityModelDAO.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//


import CoreData
import Foundation

class CityModelDAO: GenericDAO<CityInfo, CityCREntity> {
    typealias DataObjectType = CityInfo
    
    let historyDAO: GenericDAO<HistoricalInfo, WeatherInfoCREntity>
    
    init(context: NSManagedObjectContext,
         historyDAO: GenericDAO<HistoricalInfo, WeatherInfoCREntity>) {
        self.historyDAO = historyDAO
        
        super.init(context: context)
    }
    
    func create(_ plain: CityInfo, _ completion: @escaping () -> Void) {
        self.entityExists(plain) { exists in
            if exists == false {
                if let entity = self.createManagedObject(plain) as? CityCREntity,
                   let history = plain.history {
                    history.forEach({
                        if let weather = self.historyDAO.createManagedObject($0) as? WeatherInfoCREntity {
                            entity.addToHistory(weather)
                        }
                    })
                }
            }
        }
        completion()
    }
    
    func entityExists(_ plain: CityInfo, _ completion: @escaping (_ exists: Bool) -> Void) {
        self.getAll { city in
            let exists = city?.contains(where: { $0.city.id == plain.city.id }) ?? false
            completion(exists)
        }
    }
    
    override func update(_ plain: CityInfo, completion: EmptyClosureType?) {
        guard let predicate = plain.predicate else { return }
        
        self.get(predicate) { records in
            guard let record = records?.first as? CityCREntity,
                  let entity = plain.toManagedObject(object: record) as? CityCREntity
            else { return }
            
            if let history = plain.history {
                for weather in history {
                    self.historyDAO.entityExists(weather) { exists in
                        if exists {
                            self.historyDAO.update(weather, completion: nil)
                        } else {
                            if let weaterEntity = self.historyDAO.createManagedObject( weather) as? WeatherInfoCREntity {
                                entity.addToHistory(weaterEntity)
                            }
                        }
                    }
                }
            }
            completion?()
        }
    }
}
