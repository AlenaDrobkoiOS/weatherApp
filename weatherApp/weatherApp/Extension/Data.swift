//
//  Data.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation

extension Data {
    public func convertToDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
