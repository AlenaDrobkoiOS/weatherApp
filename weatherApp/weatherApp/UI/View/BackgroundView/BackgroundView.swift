//
//  BackgroundView.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit

/// Custom background - gradient with image in the bottom
final class BackgroundView: View {
    
    private let backgroundView = UIView()
    private let backgroundImageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reload()
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        addSubview(backgroundView)
        backgroundView.addSubview(backgroundImageView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        reload()
    }
    
    func addImage(_ image: UIImage?) {
        backgroundImageView.image = image
    }
    
    func reload() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [Style.Color.lightBackgroundColor.cgColor,
                           Style.Color.darkBackgroundColor.cgColor]
        backgroundView.layer.insertSublayer(gradient, at: 0)
    }
}
