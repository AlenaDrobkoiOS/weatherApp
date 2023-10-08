//
//  ServiceHolder.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

/// Service protocol
public protocol Service {}

/// Service Holder
public final class ServiceHolder {
    /// Services dictionary
    private var servicesDictionary: [String: Service] = [:]
    
    /// add Service
    public func add<T>(_ protocolType: T.Type, for instance: Service, with name: String? = nil) {
        let name = name ?? String(reflecting: protocolType)
        servicesDictionary[name] = instance
    }
    
    /// get service by Type
    public func get<T>(by type: T.Type = T.self) -> T {
        return get(by: String(reflecting: type))
    }
    
    /// get service by name
    public func get<T>(by name: String) -> T {
        guard let service = servicesDictionary[name] as? T else {
            fatalError("firstly you have to add the service")
        }
        
        return service
    }
}
