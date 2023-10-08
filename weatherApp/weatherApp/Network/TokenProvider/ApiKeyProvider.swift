//
//  ApiKeyProvider.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

/// Api key provider:  return current api key
final class ApiKeyProvider: AuthorizationTokenProvider {
    
    static let shared = ApiKeyProvider()
    
    func token() -> String? {
        return "f5cb0b965ea1564c50c6f1b74534d823"
    }
}
