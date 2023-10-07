//
//  Constants.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation

/// Helps with constant value
struct Constants {
    static var baseURL: URL {
        guard let url = URL(string: "https://openweathermap.org") else {
            fatalError("Failed attempt create URL instance https://openweathermap.org")
        }
        return url
    }
    
    static let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let outputDateFormat = "MM/dd/yyyy"
    
    static let country = "us"
}
