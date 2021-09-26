//
//  RequestParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public struct RequestParameters {
    public enum Authentication {
        case none
        case required
        case sendIfAvailable
    }
    
    public var urlQuery: URLQueryConvertible? = nil
    public var body: BodyConvertible? = nil
    public var authentication: Authentication = .none
    public var headers: [String: String] = [:]
    
    public init(urlQuery: URLQueryConvertible? = nil, body: BodyConvertible? = nil, authentication: RequestParameters.Authentication = .none, headers: [String : String] = [:]) {
        self.urlQuery = urlQuery
        self.body = body
        self.authentication = authentication
        self.headers = headers
    }
}
