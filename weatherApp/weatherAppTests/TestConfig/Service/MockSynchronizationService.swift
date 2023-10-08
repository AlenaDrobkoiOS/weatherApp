//
//  MockSynchronizationService.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import Foundation
@testable import weatherApp

class MockSynchronizationService: SynchronizationSericeType {
    func getCities(completion: @escaping ([CityInfo]?) -> Void) {
        // Mock CityInfo data for testing
        let city1 = CityInfo(city: City(id: 1, name: "City1", country: "Country1"), history: nil)
        let city2 = CityInfo(city: City(id: 2, name: "City2", country: "Country2"), history: nil)
        completion([city1, city2])
    }
    
    func addCityInfo(_ cityInfo: CityInfo, completion: @escaping EmptyClosureType) {
        completion()
    }
    
    func getCityHistory(for city: City, completion: @escaping ([HistoricalInfo]?) -> Void) {
        // Mock HistoricalInfo data for testing
        let history1 = HistoricalInfo(weatherInfo: WeatherDetailInfoViewModel(iconID: "01d", description: "Sunny", windSpeeped: "10", humidity: "60", temperature: "25"), date: Date())
        let history2 = HistoricalInfo(weatherInfo: WeatherDetailInfoViewModel(iconID: "02d", description: "Partly Cloudy", windSpeeped: "12", humidity: "55", temperature: "22"), date: Date())
        completion([history1, history2])
    }
}
