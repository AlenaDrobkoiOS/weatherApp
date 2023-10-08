//
//  City.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

/// Simple city model
struct City: Codable, Equatable {
    var id: Int
    var name: String
    var country: String
    
    init(id: Int, name: String, country: String) {
        self.id = id
        self.name = name
        self.country = country
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.country = ""
    }
}
