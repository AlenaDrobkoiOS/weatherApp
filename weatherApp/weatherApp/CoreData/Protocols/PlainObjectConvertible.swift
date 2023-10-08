//
//  PlainObjectConvertible.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

/// Protocol for NSManagedObject
protocol PlainObjectConvertible {
    
    associatedtype PlainObject
    
    /// Convert to PlainObject
    func toPlainObject() -> PlainObject
}
