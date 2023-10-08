//
//  WeatherRequestData.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

/// Request data for Weather request
struct WeatherRequestData: Codable {
    let city: String // City name, state code and country code divided by comma, Please refer to ISO 3166 for the state codes or country codes. You can specify the parameter not only in English. In this case, the API response should be returned in the same language as the language of requested location name if the location is in our predefined list of more than 200,000 locations.
    let appid: String // Your unique API key (you can always find it on your account page under the "API key" tab)
    let mode: String // Response format. Possible values are xml and html. If you don't use the mode parameter format is JSON by default. Learn more
    let units: String // Units of measurement. standard, metric and imperial units are available. If you do not use the units parameter, standard units will be applied by default.
    let lang: String // You can use this parameter to get the output in your language.
    
    enum CodingKeys: String, CodingKey {
        case city = "q"
        case appid
        case mode
        case units
        case lang
    }
}
