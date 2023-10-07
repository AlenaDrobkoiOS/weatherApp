//
//  UIView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import UIKit

// MARK: Xib load routine
extension UIView {
    static var describing: String {
        return String(describing: self)
    }
    
    private func setupView(subView: UIView) {
        backgroundColor = .clear
        subView.frame = bounds
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subView)
        leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 0).isActive = true
        topAnchor.constraint(equalTo: subView.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 0).isActive = true
        subView.backgroundColor = .clear
    }
}

// MARK: Round Corners
extension UIView {
    func setCornersRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func roundedView() {
        superview?.layoutIfNeeded()
        setCornersRadius(frame.width / 2)
    }
    
    func addShadowAndRadius(color: UIColor = UIColor.black,
                            shadowOpacity: Float = 0.1,
                            cornerRadius: CGFloat = 10) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        layer.masksToBounds = false
        layer.shadowRadius = 10.0
        layer.shadowOpacity = shadowOpacity
        layer.cornerRadius = cornerRadius
    }
}
