//
//  JSONParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class JSONParameters: URLParameters {
    public static let encoder = JSONEncoder()
    
    // MARK: -
    private var dataClosure: (() throws -> Data)?
    public var data: Data?
    
    public init<T: Encodable>(_ body: T, headers: [String: String] = [:]) {
        super.init(headers: headers)
        
        self.dataClosure = { return try JSONParameters.encoder.encode(body) }
        self.headers["Content-Type"] = "application/json"
    }
    
    public override func getData() throws -> Data? {
        if data == nil {
            data = try dataClosure?()
        }
        return data
    }
}

public protocol CustomDateEncoding {
    var dateFormat: String { get }
    var locale: Locale { get }
}

public extension CustomDateEncoding {
    var locale: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
}
