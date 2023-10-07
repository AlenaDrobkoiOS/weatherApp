//
//  City.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

/// City model for dispalying list of city
struct City: Codable {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {
        self.id = ""
        self.name = ""
    }
}
