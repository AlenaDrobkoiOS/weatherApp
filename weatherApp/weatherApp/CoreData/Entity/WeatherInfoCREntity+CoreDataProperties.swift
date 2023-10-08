//
//  WeatherInfoCREntity+CoreDataProperties.swift
//  
//
//  Created by Alena Drobko on 08.10.23.
//
//

import Foundation
import CoreData

extension WeatherInfoCREntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherInfoCREntity> {
        return NSFetchRequest<WeatherInfoCREntity>(entityName: "WeatherInfoCREntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var iconUrl: String?
    @NSManaged public var temperature: String?
    @NSManaged public var humidity: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var windSpeed: String?
    @NSManaged public var city: CityCREntity?
}

extension WeatherInfoCREntity: Identifiable { }
