//
//  FormURLParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class FormURLParameters: URLParameters {
    
    public var formParameters: URLQueryConvertible?
    
    public init(formParameters: URLQueryConvertible? = nil, headers: [String: String] = [:], authenticate: Bool = false) {
        super.init(headers: headers, authenticate: authenticate)
        
        self.formParameters = formParameters
        self.headers["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    public override func getData() throws -> Data? {
        guard let query = formParameters?.urlQuery else { return nil }
        return query.data(using: .utf8, allowLossyConversion: false)
    }
}
