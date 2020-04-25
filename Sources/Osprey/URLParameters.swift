//
//  BasicRequestParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class URLParameters: RequestParameters {
    
    // MARK: -
    public var urlParameters: [String: Any]? = nil
    
    // MARK: - Commmon
    public var headers: [String: String] = [:]
    
    public init(_ urlParameters: [String: Any]? = nil, headers: [String: String] = [:]) {
        self.urlParameters = urlParameters
        self.headers = headers
    }
    
    public func getData() throws -> Data? {
        return nil
    }
}
