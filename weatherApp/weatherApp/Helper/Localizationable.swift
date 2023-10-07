//
//  Localizationable.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation

protocol LocalizableDelegate {
    var rawValue: String { get } //localize key
    var localized: String { get }
}

extension LocalizableDelegate {
    ///returns a localized value by specified key located in the specified table
    var localized: String {
        return rawValue.localized
    }
}

/// Helps with localization
enum Localizationable {
    enum Global: String, LocalizableDelegate {
        case cityTitle = "Global.cityTitle"
        case error = "Global.error"
        case warning = "Global.warning"
        case ok = "Global.OK"
        case openInfo = "Global.openInfo"
        case urlWarning = "Global.urlWarning"
        case noElementsWarning = "Global.noElementsWarning"
        case countWarning = "Global.countWarning"
        case search = "Global.search"
        case searchInfo = "Global.searchInfo"
        case footerText = "Global.footerText"
        case description = "Global.description"
        case temperature = "Global.temperature"
        case humidity = "Global.humidity"
        case windspeed = "Global.windspeed"
        case historical = "Global.historical"
    }
}
