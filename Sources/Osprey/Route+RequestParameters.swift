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
    func appending(parameters: URLQueryStringConvertible) throws -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw RepositoryError.encodingError
        }
        let percentEncodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + parameters.urlQueryString
        components.percentEncodedQuery = percentEncodedQuery
        if let url = components.url {
            return url
        }
        throw RepositoryError.encodingError
    }
}

public protocol URLQueryStringConvertible {
    var urlQueryString: String { get }
}

extension Dictionary: URLQueryStringConvertible where Key: CustomStringConvertible {
    public var urlQueryString: String {
        let string = self.map({ "\($0)=\(String(describing: $1))" }).joined(separator: "&")
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

extension URLQueryStringConvertible where Self: CustomStringConvertible {
    var urlQueryString: String {
        return self.description
    }
}
