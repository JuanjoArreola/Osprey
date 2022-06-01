//
//  Route+URLQueryConvertible.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public extension Route {
    func getURL(with query: URLQueryConvertible?) throws -> URL {
        let url = try getURL()
        if let query = query {
            return try url.appending(query: query)
        }
        return url
    }
}

public extension URL {
    func appending(query: URLQueryConvertible) throws -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw RoutingError.encodingError
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.appending("&" + query.urlQuery) ?? query.urlQuery
        if let url = components.url {
            return url
        }
        throw RoutingError.encodingError
    }
}
