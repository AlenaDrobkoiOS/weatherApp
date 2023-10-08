//
//  CityInfo.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.23.
//

import Foundation

/// City model with city info and history
struct CityInfo: Codable, Equatable {
    var city: City
    var history: [HistoricalInfo]?
    
    init(city: City, history: [HistoricalInfo]?) {
        self.city = city
        self.history = history
    }
    
    init() {
        self.city = .init()
        self.history = nil
    }
    
    init(responce: WeatherResponce) {
        self.city = .init(id: responce.id ?? 0,
                          name: responce.name?.uppercased() ?? "n/a",
                          country: responce.sys?.country ?? "n/a")
        
        let weather = WeatherDetailInfoViewModel(iconID: responce.weather?.first?.icon,
                                                 description: responce.weather?.first?.main ?? "n/a",
                                                 windSpeeped: "\(responce.wind?.speed ?? 0)",
                                                 humidity: "\(responce.main?.humidity ?? 0)",
                                                 temperature: "\(responce.main?.temp ?? 0)")
        self.history = [HistoricalInfo(weatherInfo: weather, date: Date())]
    }
}
