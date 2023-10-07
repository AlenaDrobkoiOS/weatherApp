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
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor,
                           Style.Color.backgroundColor?.cgColor ?? UIColor.white]
        backgroundView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.addSubview(backgroundView)
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
        
        backgroundImageView.image = Style.Images.background.image
    }
}
