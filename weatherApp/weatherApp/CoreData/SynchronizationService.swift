//
//  SyncronizationService.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

protocol SynchronizationSericeType: Service {

    /// get all city from local storage
    func getCities(completion: @escaping (_ activity: [CityInfo]?) -> Void)
    
    /// add city info to local storage
    func addCityInfo(_ cityInfo: CityInfo, completion: @escaping EmptyClosureType)
    
    /// get all history for city from local storage
    func getCityHistory(for city: City, completion: @escaping (_ activity: [HistoricalInfo]?) -> Void)
}

/// Local Storage service
class SynchronizationSerice: SynchronizationSericeType {
    /// Entity history data acsses object
    var historyActivityDAO: GenericDAO<HistoricalInfo, WeatherInfoCREntity>
    var cityDAO: CityModelDAO
    
    init(historyActivityDAO: GenericDAO<HistoricalInfo, WeatherInfoCREntity>,
         cityDAO: CityModelDAO) {
        self.historyActivityDAO = historyActivityDAO
        self.cityDAO = cityDAO
    }
    
    /// get all city from local storage
    func getCities(completion: @escaping (_ activity: [CityInfo]?) -> Void) {
        cityDAO.getAll(completion: completion)
    }
    
    /// add city info to local storage
    func addCityInfo(_ cityInfo: CityInfo, completion: @escaping EmptyClosureType) {
        self.cityDAO.entityExists(cityInfo) { [self] exitsts in
            if exitsts == true {
                self.cityDAO.update(cityInfo) {
                    self.cityDAO.save()
                    completion()
                }
            } else {
                self.cityDAO.create(cityInfo) {
                    self.cityDAO.save()
                    completion()
                }
            }
        }
    }
    
    /// get all history for city from local storage
    func getCityHistory(for city: City, completion: @escaping (_ activity: [HistoricalInfo]?) -> Void) {
        let predicate = NSPredicate(format: "city.id == %d", Int64(city.id))
        let sort = NSSortDescriptor(key: "date", ascending: false)
        historyActivityDAO.get(predicate, sort, nil, completion: completion)
    }
}
