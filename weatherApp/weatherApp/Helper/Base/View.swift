//
//  View.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation
import UIKit

/// Base protocol for all custom view with viewModel
public protocol ViewProtocol: DeinitLoggerType {
    associatedtype ViewModelType: ViewModelProtocol
    
    var viewModel: ViewModelType! { get set }
    
    func setupOutput()
    func setupInput(input: ViewModelType.Output)
}

/// Base class for all custom view
class View: UIView, DeinitLoggerType {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setupView()
        setupLocalization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupConstraints()
        setupView()
        setupLocalization()
    }
    
//    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        setupView()
//    }
    
    
    // MARK: - Fucntions
    
    open func setupView() {}
    
    open func setupConstraints() {}
    
    open func setupLocalization() {}
}
