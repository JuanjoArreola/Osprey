//
//  HttpRequester.swift
//  Osprey
//
//  Created by JuanJo on 22/06/20.
//

import Foundation

open class HttpRequester {
    open var cachePolicy: URLRequest.CachePolicy?
    open var timeoutInterval: TimeInterval?
    open var allowsCellularAccess: Bool?
    open var session: URLSession?
    
    func request(route: Route, parameters: RequestParameters?) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: try route.getURL(with: parameters?.urlQuery))
        request.httpBody = parameters?.body?.data
        parameters?.headers.forEach({ request.addValue($0.value, forHTTPHeaderField: $0.key) })
        
        request.httpMethod = route.httpMethod
        request.cachePolicy = cachePolicy ?? request.cachePolicy
        request.timeoutInterval = timeoutInterval ?? request.timeoutInterval
        request.allowsCellularAccess = allowsCellularAccess ?? request.allowsCellularAccess
        
        let session = self.session ?? URLSession.shared
        return try await session.data(for: request)
    }
}
