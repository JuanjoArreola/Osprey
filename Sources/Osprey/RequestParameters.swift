//
//  RequestParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public protocol RequestParameters: class {
    var urlParameters: URLQueryConvertible? { get }
    var headers: [String: String] { get set }
    var requiresAuthentication: Bool { get }
    
    func getData() throws -> Data?
    func preprocess() throws
}

public extension RequestParameters {
    func preprocess() throws {}
}
