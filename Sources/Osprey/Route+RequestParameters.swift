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
    func appending(parameters: [String: Any]) throws -> URL {
        guard let queryString = parameters.urlQueryString,
              var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw RepositoryError.encodingError
        }
        let percentEncodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + queryString
        components.percentEncodedQuery = percentEncodedQuery
        if let url = components.url {
            return url
        }
        throw RepositoryError.encodingError
    }
}

public extension Dictionary where Key: ExpressibleByStringLiteral {
    var urlQueryString: String? {
        let string = self.map({ "\($0)=\(String(describing: $1))" }).joined(separator: "&")
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
