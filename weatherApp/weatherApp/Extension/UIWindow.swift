//
//  UIWindow.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}
