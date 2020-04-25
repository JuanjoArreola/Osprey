//
//  AbstractAPI.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation
import ShallowPromises

extension URLSessionDataTask: Cancellable {}

private let processingQueue = DispatchQueue(label: "com.osprey.ProcessingQueue", attributes: .concurrent)

open class AbstractAPI: BaseRepository {
    
    public let responseParser: ResponseParser
    open var responseQueue = DispatchQueue.main
    
    public init(responseParser: ResponseParser) {
        self.responseParser = responseParser
        super.init()
    }
    
    open func request<T: Decodable>(route: Route, parameters: RequestParameters? = nil) -> Promise<T> {
        let promise = Promise<T>()
        processingQueue.async {
            do {
                promise.littlePromise = try self.request(route: route, parameters: parameters, completion: { (data, response, error) in
                    self.parseData(data, response: response, error: error, promise: promise)
                })
            } catch {
                promise.complete(with: error, in: self.responseQueue)
            }
        }
        
        return promise
    }
    
    func parseData<T: Decodable>(_ data: Data?, response: URLResponse?, error: Error?, promise: Promise<T>) {
        do {
            if let error = try parseError(data: data, response: response, error: error) {
                promise.complete(with: error, in: responseQueue)
            } else if let data = data {
                let result: T = try responseParser.getInstance(from: data, response: response)
                promise.fulfill(with: result, in: responseQueue)
            } else {
                promise.complete(with: ResponseError.emptyResponse, in: responseQueue)
            }
        } catch {
            promise.complete(with: error, in: responseQueue)
        }
    }
    
    // MARK: - Parse error
    
    public func parseError(data: Data?, response: URLResponse?, error: Error?) throws -> Error? {
        if let error = error {
            return error
        }
        if let data = data, let error = try responseParser.getError(from: data, response: response) {
            return error
        }
        if let code = (response as? HTTPURLResponse)?.statusCode, code >= 400, code < 600 {
            if let error = parseError(code: code, data: data, response: response) {
                return error
            }
            return ResponseError.httpError(statusCode: code, content: data)
        }
        return nil
    }
    
    open func parseError(code: Int, data: Data?, response: URLResponse?) -> Error? {
        switch code {
        case 404:
            if let url = response?.url {
                return ResponseError.notFound(url: url)
            }
            return nil
        default:
            return nil
        }
    }
}
