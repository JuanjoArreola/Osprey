//
//  QueryParameters.swift
//  Osprey
//
//  Created by JuanJo on 10/07/20.
//

import Foundation

public struct QueryParameters: URLQueryStringConvertible {
    public var array = [URLQueryStringConvertible]()
    
    public init(_ elements: URLQueryStringConvertible?...) {
        array.append(contentsOf: elements.compactMap({ $0 }))
    }
    
    public mutating func add(_ element: URLQueryStringConvertible?) {
        if let element = element {
            array.append(element)
        }
    }
    
    public mutating func add(_ key: String, value: CustomStringConvertible?) {
        if let value = value {
            array.append([key: value])
        }
    }
    
    public var urlQueryString: String {
        return array.compactMap({ $0.urlQueryString }).joined(separator: "&")
    }
}
