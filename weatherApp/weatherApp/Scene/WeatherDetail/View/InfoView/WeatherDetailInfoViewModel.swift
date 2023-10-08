//
//  WeatherDetailInfoViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

struct WeatherDetailInfoViewModel: Codable {
    let iconID: String?
    
    let description: String
    let windSpeeped: String
    let humidity: String
    let temperature: String
    
    init(iconID: String?,
         description: String,
         windSpeeped: String,
         humidity: String,
         temperature: String) {
        self.iconID = iconID
        
        self.description = description
        self.windSpeeped = windSpeeped
        self.humidity = humidity
        self.temperature = temperature
    }
    
    init() {
        self.iconID = nil
        
        self.description = ""
        self.windSpeeped = ""
        self.humidity = ""
        self.temperature = ""
    }
}
