//
//  URLQuery.swift
//  
//
//  Created by JuanJo on 25/09/21.
//

import Foundation

public struct URLQuery: URLQueryConvertible {
    public var array = [URLQueryConvertible]()
    
    public init(_ elements: URLQueryConvertible?...) {
        array.append(contentsOf: elements.compactMap({ $0 }))
    }
    
    public init(_ elements: [URLQueryConvertible?]) {
        array.append(contentsOf: elements.compactMap({ $0 }))
    }
    
    public mutating func add(_ element: URLQueryConvertible?) {
        if let element = element {
            array.append(element)
        }
    }
    
    public mutating func add(_ key: String, value: URLQueryValueConvertible?) {
        if let value = value {
            array.append([key: value.urlQueryValue])
        }
    }
    
    public var urlQuery: String {
        return array.compactMap({ $0.urlQuery }).joined(separator: "&")
    }
}
