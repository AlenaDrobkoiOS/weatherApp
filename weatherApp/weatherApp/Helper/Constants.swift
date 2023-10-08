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
        guard let url = URL(string: "https://api.openweathermap.org") else {
            fatalError("Failed attempt create URL instance https://openweathermap.org")
        }
        return url
    }
    
    static let inputDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let outputDateFormat = "MM/dd/yyyy"
    
    static let dateFormat = "dd.MM.yyyy' - 'HH:mm"
    
    static let lang = "en"
    static let mode = "JSON"
    static let units = "metric"
    
    static func getImageUrl(image: String?) -> String {
        let text = "http://openweathermap.org/img/w/<ICON_ID>.png"
        let image = image ?? ""
        return text.replacingOccurrences(of: "<ICON_ID>", with: image)
    }
}
