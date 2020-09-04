//
//  QueryParameters.swift
//  Osprey
//
//  Created by JuanJo on 10/07/20.
//

import Foundation

public protocol URLQueryConvertible {
    var urlQuery: String { get }
}

public protocol URLQueryValueConvertible {
    var urlQueryValue: String { get }
}

extension Dictionary: URLQueryConvertible where Key: CustomStringConvertible {
    public var urlQuery: String {
        let string = self.map({ "\($0)=\(String(describing: $1))" }).joined(separator: "&")
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

extension CustomStringConvertible where Self: URLQueryValueConvertible {
    public var urlQueryValue: String {
        return self.description
    }
}

public struct URLQuery: URLQueryConvertible {
    public var array = [URLQueryConvertible]()
    
    public init(_ elements: URLQueryConvertible?...) {
        array.append(contentsOf: elements.compactMap({ $0 }))
    }
    
    public mutating func add(_ element: URLQueryConvertible?) {
        if let element = element {
            array.append(element)
        }
    }
    
    public mutating func add(_ key: String, value: URLQueryValueConvertible?) {
        if let value = value {
            array.append([key: value])
        }
    }
    
    public var urlQuery: String {
        return array.compactMap({ $0.urlQuery }).joined(separator: "&")
    }
}
