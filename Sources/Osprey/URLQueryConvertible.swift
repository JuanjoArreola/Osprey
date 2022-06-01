//
//  URLQueryConvertible.swift
//  Osprey
//
//  Created by JuanJo on 10/07/20.
//

import Foundation

/// A type that can be converted to a valid URL Query String of the form: key=value
///
/// Conforming to the URLQueryConvertible Protocol
/// ==================================================
///
/// Add `URLQueryConvertible` conformance to your custom types by defining
/// a `urlQuery` property.
///
/// For example, to send a CLLocationCoordinate2D in the URL Query String of a request
/// add conformance to `URLQueryConvertible`:
///
///     extension CLLocationCoordinate2D: URLQueryConvertible {
///         public var urlQueryString: String {
///             return "latitude=\(latitude)&longitude=\(longitude)"
///         }
///     }
/// Calling `addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)` on
/// the return value is advised depending on the case, since later methods won't call it before sending
/// the request.
public protocol URLQueryConvertible {
    var urlQuery: String { get }
}

/// A type that can be converted to a String that represents
/// only the value part of the URL Query string *key=value*
public protocol URLQueryValueConvertible {
    var urlQueryValue: String { get }
}

extension Dictionary: URLQueryConvertible where Key: CustomStringConvertible {
    public var urlQuery: String {
        return self.map({
            let value = ($1 as? URLQueryValueConvertible)?.urlQueryValue ?? String(describing: $1)
            return "\($0)=\(value)"
        }).joined(separator: "&")
    }
}

extension CustomStringConvertible where Self: URLQueryValueConvertible {
    public var urlQueryValue: String {
        return self.description
    }
}
