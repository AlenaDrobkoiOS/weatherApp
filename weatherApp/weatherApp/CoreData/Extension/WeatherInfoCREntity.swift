//
//  WeatherInfoCREntity.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.23.
//

import Foundation
import CoreData

extension WeatherInfoCREntity: PlainObjectConvertible {
    typealias PlainObject = HistoricalInfo
    
    func toPlainObject() -> HistoricalInfo {
        
        return HistoricalInfo.init(weatherInfo: .init(iconID: self.iconUrl,
                                                      description: self.weatherDescription ?? "n/a",
                                                      windSpeeped: self.windSpeed ?? "n/a",
                                                      humidity: self.humidity ?? "n/a",
                                                      temperature: self.temperature ?? "n/a"),
                                   date: self.date ?? Date())
    }
}

extension HistoricalInfo: ManagedObjectConvertible {
    var predicate: NSPredicate? {
        return NSPredicate(format: "date == %lu", date as NSDate)
    }
    
    func entityType() -> NSManagedObject.Type {
        return WeatherInfoCREntity.self
    }
    
    func toManagedObject(object: NSManagedObject) -> NSManagedObject? {
        let weatherEntity = object as? WeatherInfoCREntity
        weatherEntity?.iconUrl = weatherInfo.iconID
        weatherEntity?.windSpeed = weatherInfo.windSpeeped
        weatherEntity?.weatherDescription = weatherInfo.description
        weatherEntity?.humidity = weatherInfo.humidity
        weatherEntity?.temperature = weatherInfo.temperature
        weatherEntity?.date = date
        return weatherEntity
    }
}
