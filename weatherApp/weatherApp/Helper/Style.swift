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
        static let textColor = UIColor(named: "textColor")
        static let backgroundColor = UIColor(named: "backgroundColor")
    }
    
    /// Contains different fonts
    struct Font {
        static let boldText = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let semiboldText = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let mediumText = UIFont.systemFont(ofSize: 14, weight: .medium)
        static let regularMidleText = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let regularSmallText = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
