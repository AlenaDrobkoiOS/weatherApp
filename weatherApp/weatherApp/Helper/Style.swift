//
//  Style.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import UIKit

/// Helps with Colors, Fonts and another parametrs for UI elements
struct Style {
    /// Contains different images
    enum Images: String {
        case placeholder
        case background
        case buttonRight
        case buttonLeft
        case buttonModal
        case arrowLeft
        case plus
        case xmark
        case info
        case arrowRight

        var imageName: String {
            switch self {
            case .placeholder, .background, .buttonLeft,
                    .buttonModal, .buttonRight, .plus, .xmark:
                return rawValue
            case .arrowLeft:
                return "arrow.left"
            case .info:
                return "info.circle"
            case .arrowRight:
                return "chevron.right"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .placeholder, .background, .buttonLeft,
                    .buttonModal, .buttonRight:
                return UIImage(named: self.imageName)
            case .arrowLeft, .plus, .xmark, .info, .arrowRight:
                return UIImage(systemName: self.imageName)
            }
        }
    }
    
    /// Contains different colors
    struct Color {
        static let textColor = UIColor(named: "labelColor")
        static let lightBackgroundColor = UIColor(named: "lightBackgroundColor")
        static let darkBackgroundColor = UIColor(named: "darkBackgroundColor")
    }
    
    /// Contains different fonts
    struct Font {
        static let boldText = UIFont(name: "SFProText-Bold", size: 24) ?? .init()
        static let semiboldText = UIFont(name: "SFProText-Semibold", size: 16) ?? .init()
        static let mediumText = UIFont(name: "SFProText-Medium", size: 14) ?? .init()
        static let regularMidleText = UIFont(name: "SFProText-Regular", size: 16) ?? .init()
        static let regularSmallText = UIFont(name: "SFProText-Regular", size: 12) ?? .init()
    }
}
