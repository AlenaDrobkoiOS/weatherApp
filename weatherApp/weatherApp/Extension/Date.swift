//
//  Date.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func getString() -> String {
        let formater = DateFormatter()
        formater.dateFormat = Constants.dateFormat
        return formater.string(from: self)
    }
}
