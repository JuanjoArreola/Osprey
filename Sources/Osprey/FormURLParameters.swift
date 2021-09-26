//
//  FormURLParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public struct FormURLBody: BodyConvertible {
    public var data: Data
    public var headers: [String : String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    public init(query: URLQueryConvertible? = nil) {
        self.data = query?.urlQuery.data(using: .utf8, allowLossyConversion: false) ?? Data()
    }
}
