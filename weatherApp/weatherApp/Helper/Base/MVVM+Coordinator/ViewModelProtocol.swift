//
//  ViewModelProtocol.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation

///Base protocol for all view model
public protocol ViewModelProtocol: DeinitLoggerType {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input,
                   outputHandler: @escaping (_ output: Output) -> Void)
}
