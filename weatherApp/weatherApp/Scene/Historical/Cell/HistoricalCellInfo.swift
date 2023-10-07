//
//  HistoricalCellInfo.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

/// HistoricalInfo about weather in city at date
struct HistoricalInfo {
    let weatherInfo: WeatherDetailInfoViewModel
    let date: Date
    
    init(weatherInfo: WeatherDetailInfoViewModel, date: Date) {
        self.weatherInfo = weatherInfo
        self.date = date
    }
    
    init() {
        self.weatherInfo = .init()
        self.date = .init()
    }
}
