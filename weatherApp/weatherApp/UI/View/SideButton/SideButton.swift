//
//  SideButton.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import SnapKit

enum SideButtonState {
    case left
    case right
    case modal
}

/// Custom side button (blue with white sign)
final class SideButton: UIButton {
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sideButtonState: SideButtonState? {
        didSet {
            self.backgroundColor = UIColor.tintColor
            
            switch sideButtonState {
            case .left:
                self.layer.maskedCorners = [.layerMinXMinYCorner,
                                            .layerMinXMaxYCorner]
                self.setImage(Style.Images.arrowLeft.image, for: .normal)
            case .right:
                self.layer.maskedCorners = [.layerMaxXMaxYCorner,
                                            .layerMaxXMinYCorner]
                self.setImage(Style.Images.plus.image, for: .normal)
            case .modal:
                self.layer.maskedCorners = [.layerMaxXMaxYCorner]
                self.setImage(Style.Images.xmark.image, for: .normal)
            case .none:
                self.backgroundColor = UIColor.clear
                self.setImage(UIImage(), for: .normal)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpUI()
    }
    
    func setUpUI() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.25
        
        self.layer.cornerRadius = 20
        
        self.imageView?.tintColor = .white
        self.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
    }
}
