//
//  AbstractAPI.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class AbstractAPI {
    
    public let responseParser: ResponseParser
    public var requester: HttpRequester = {
        var requester = HttpRequester()
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        requester.session = URLSession(configuration: config)
        
        return requester
    }()
    
    public init(responseParser: ResponseParser) {
        self.responseParser = responseParser
    }
    
    open func request<T: Decodable>(route: Route, parameters: RequestParameters? = nil) async throws -> T {
        var params = parameters ?? RequestParameters()
        try processParameters(&params, route: route)
        let (data, response) = try await requester.request(route: route, parameters: params)
        try parseError(data: data, response: response)
        return try responseParser.getInstance(from: data, response: response)
    }
    
    open func request(route: Route, parameters: RequestParameters? = nil) async throws {
        var params = parameters ?? RequestParameters()
        try processParameters(&params, route: route)
        let (data, response) = try await requester.request(route: route, parameters: params)
        try parseError(data: data, response: response)
    }
    
    // MARK: - Parse error
    
    public func parseError(data: Data, response: URLResponse) throws {
        guard let code = (response as? HTTPURLResponse)?.statusCode, !(200..<400).contains(code) else {
            return
        }
        try responseParser.parseError(from: data, response: response)
        try parseError(code: code, data: data, response: response)
        throw ResponseError.httpError(statusCode: code, content: data)
    }
    
    open func parseError(code: Int, data: Data, response: URLResponse) throws {
        switch code {
        case 404:
            if let url = response.url {
                throw ResponseError.notFound(url: url)
            }
        default:
            return
        }
    }
    
    open func processParameters(_ parameters: inout RequestParameters, route: Route) throws {
        if let header = responseParser.acceptHeader {
            parameters.headers["Accept"] = header
        }
        if let headers = parameters.body?.headers {
            parameters.headers.merge(headers, uniquingKeysWith: { (_, new) in new })
        }
    }
}
