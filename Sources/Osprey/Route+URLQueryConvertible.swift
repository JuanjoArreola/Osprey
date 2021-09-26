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
        guard let query = query.urlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw RoutingError.invalidURLQuery
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.appending("&" + query) ?? query
        if let url = components.url {
            return url
        }
        throw RoutingError.encodingError
    }
}
