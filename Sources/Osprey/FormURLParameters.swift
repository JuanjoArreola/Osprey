//
//  FormURLParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class FormURLParameters: URLParameters {
    
    public var formParameters: [String: Any]?
    
    public init(formParameters: [String: Any]? = nil, headers: [String: String] = [:]) {
        super.init(headers: headers)
        
        self.formParameters = formParameters
        self.headers["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    public override func getData() throws -> Data? {
        guard let query = formParameters?.urlQueryString else { return nil }
        return query.data(using: .utf8, allowLossyConversion: false)
    }
}
