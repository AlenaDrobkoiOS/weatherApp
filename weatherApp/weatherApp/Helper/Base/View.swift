//
//  View.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation

/// Base protocol for all custom view
public protocol ViewProtocol: DeinitLoggerType {
    associatedtype ViewModelType: ViewModelProtocol
    
    var viewModel: ViewModelType! { get set }

    func setupOutput()
    func setupInput(input: ViewModelType.Output)
}
