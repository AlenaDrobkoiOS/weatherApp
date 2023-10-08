//
//  AuthorizationTokenProvider.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

/// Protocol for any token, api key or another auth kind provider
public protocol AuthorizationTokenProvider {
    func token() -> String?
}
