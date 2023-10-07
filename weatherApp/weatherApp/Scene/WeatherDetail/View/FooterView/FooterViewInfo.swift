//
//  FooterViewInfo.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

struct FooterViewInfo {
    let city: String
    let date: Date
    
    init(city: String, date: Date) {
        self.city = city
        self.date = date
    }
    
    init() {
        self.city = ""
        self.date = Date()
    }
}
