//
//  City.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

/// City model for dispalying list of city
struct City: Codable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {
        self.id = 0
        self.name = ""
    }
}
