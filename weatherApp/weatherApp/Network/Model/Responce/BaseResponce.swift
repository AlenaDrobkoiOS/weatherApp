//
//  BaseResponce.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

/// Protocol for responce data
public protocol BaseResponseProtocol: Codable {
    var cod: CodeValue? { get set }
    var message: String? { get set }
}

/// Base responce data model - contains info that comes with any responce
struct BaseResponse: BaseResponseProtocol {
    var cod: CodeValue?
    var message: String?
}

/// Type for dynamic code value
public enum CodeValue: Codable {
    case error(String)
    case success(Int)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .success(value)
            return
        }
        if let value = try? container.decode(String.self) {
            self = .error(value)
            return
        }
        throw DecodingError.typeMismatch(CodeValue.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for CodeValue"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .success(let value):
            try container.encode(value)
        case .error(let value):
            try container.encode(value)
        }
    }
}
