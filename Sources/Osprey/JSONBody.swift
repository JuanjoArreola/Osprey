//
//  JSONBody.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public struct JSONBody: BodyConvertible {
    public static let encoder = JSONEncoder()
    
    public var data: Data
    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    public init<T: Encodable>(_ body: T) throws {
        self.data = try Self.encoder.encode(body)
    }
}
