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

        var imageName: String {
            switch self {
            case .placeholder:
                return "placeholder"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .placeholder:
                return UIImage(named: self.imageName) // return UIImage(systemName: self.imageName)
            }
        }
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
