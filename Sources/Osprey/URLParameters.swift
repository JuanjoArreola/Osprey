//
//  BasicRequestParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class URLParameters: RequestParameters {
    
    // MARK: -
    public var urlParameters: URLQueryStringConvertible? = nil
    public var requiresAuthentication: Bool = false
    
    // MARK: - Commmon
    public var headers: [String: String] = [:]
    
    public init(_ urlParameters: URLQueryStringConvertible? = nil, headers: [String: String] = [:], authenticate: Bool = false) {
        self.urlParameters = urlParameters
        self.headers = headers
        self.requiresAuthentication = authenticate
    }
    
    public func getData() throws -> Data? {
        return nil
    }
}
