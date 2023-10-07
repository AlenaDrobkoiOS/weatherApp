//
//  Encodable.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation

public extension Encodable {
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch {
            let desc = "Failed attempt to convert Encodable object to [String: Any] dictionary."
            debugPrint("\(desc) \(error.localizedDescription)")
            return nil
        }
    }
    
    func toJsonString() -> String? {
        if let data = try? JSONEncoder().encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func asDictionaryOrEmpty() -> [String: Any] {
        asDictionary() ?? [:]
    }
    
    static func fromJsonString<T: Codable>(_ str: String) -> T? {
        if let data = str.data(using: .utf8) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    func convertToData() -> Data? {
        if let data = try? JSONEncoder().encode(self) {
            return data
        }
        return nil
    }
}
