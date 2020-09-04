//
//  Route+RequestParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public extension Route {
    func getURL(with parameters: RequestParameters?) throws -> URL {
        let url = try getURL()
        if let urlParameters = parameters?.urlParameters {
            return try url.appending(parameters: urlParameters)
        }
        return url
    }
}

public extension URL {
    func appending(parameters: URLQueryConvertible) throws -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw RoutingError.encodingError
        }
        guard let query = parameters.urlQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw RoutingError.invalidURLQuery
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.appending("&" + query) ?? query
        if let url = components.url {
            return url
        }
        throw RoutingError.encodingError
    }
}
