//
//  DoubleTextViewInfo.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

enum DoubleTextViewInfoState {
    case vertical
    case horisontal
}

struct DoubleTextViewInfo {
    let state: DoubleTextViewInfoState
    
    let title: String
    let value: String

    init(state: DoubleTextViewInfoState = .horisontal, title: String, value: String) {
        self.title = title
        self.value = value
        self.state = state
    }
    
    init() {
        self.title = ""
        self.value = ""
        self.state = .horisontal
    }
}
