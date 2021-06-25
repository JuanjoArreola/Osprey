//
//  JSONParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class JSONParameters: RequestParameters {
    public static let encoder = JSONEncoder()
    
    // MARK: -
    public var urlParameters: URLQueryConvertible? = nil
    public var requiresAuthentication: Bool = false
    public var headers: [String: String] = [:]
    
    // MARK: - Body
    private var dataClosure: (() throws -> Data)?
    public var data: Data?
    
    public init(headers: [String: String] = [:], authenticate: Bool = false) {
        self.headers = headers
        self.headers["Content-Type"] = "application/json"
        self.requiresAuthentication = authenticate
    }
    
    public convenience init<T: Encodable>(_ body: T, headers: [String: String] = [:], authenticate: Bool = false) {
        self.init(headers: headers, authenticate: authenticate)
        self.dataClosure = { return try JSONParameters.encoder.encode(body) }
    }
    
    public func getData() throws -> Data? {
        if data == nil {
            data = try dataClosure?()
        }
        return data
    }
}
