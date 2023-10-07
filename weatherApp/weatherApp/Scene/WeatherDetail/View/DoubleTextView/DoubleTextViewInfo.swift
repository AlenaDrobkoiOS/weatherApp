//
//  DoubleTextViewInfo.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

struct DoubleTextViewInfo {
    let title: String
    let value: String

    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    init() {
        self.title = ""
        self.value = ""
    }
}
