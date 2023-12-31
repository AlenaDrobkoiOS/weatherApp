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
            backgroundColor = UIColor.tintColor
            
            switch sideButtonState {
            case .left:
                layer.maskedCorners = [.layerMaxXMaxYCorner,
                                       .layerMaxXMinYCorner]
                setImage(Style.Images.arrowLeft.image, for: .normal)
            case .right:
                layer.maskedCorners = [.layerMinXMinYCorner,
                                       .layerMinXMaxYCorner]
                setImage(Style.Images.plus.image, for: .normal)
            case .modal:
                layer.maskedCorners = [.layerMaxXMaxYCorner]
                setImage(Style.Images.xmark.image, for: .normal)
            case .none:
                backgroundColor = UIColor.clear
                setImage(UIImage(), for: .normal)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUpUI()
    }
    
    func setUpUI() {
        imageView?.tintColor = .white
        imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        
        addShadowAndRadius(shadowOpacity: 0.25, cornerRadius: 20)
    }
}
