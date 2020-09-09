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
    
    public convenience init<T: Encodable>(_ body: T, headers: [String: String] = [:], authenticate: Bool = false) {
        self.init(headers: headers)
        
        self.dataClosure = { return try JSONParameters.encoder.encode(body) }
        self.headers["Content-Type"] = "application/json"
        self.requiresAuthentication = authenticate
    }
    
    public override func getData() throws -> Data? {
        if data == nil {
            data = try dataClosure?()
        }
        return data
    }
}
