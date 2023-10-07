//
//  HeaderInfo.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation

struct HeaderInfo {
    let title: String
    
    let leftButtonState: SideButtonState?
    let rightButtonState: SideButtonState?
    
    init(title: String,
         leftButtonState: SideButtonState? = nil,
         rightButtonState: SideButtonState? = nil) {
        self.title = title
        self.leftButtonState = leftButtonState
        self.rightButtonState = rightButtonState
    }
}
