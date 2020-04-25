//
//  MultipartParameters.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class MultipartParameters: URLParameters {
    public static let boundary = "Boundary-\(UUID().uuidString)"
    
    // MARK: -
    public var boundary: String?
    public var parts: [Part]?
    public var partParameters: [String: Any]?
    
    public init(parts: [Part], parameters: [String: Any]? = nil, headers: [String: String] = [:]) {
        super.init(headers: headers)
        
        self.parts = parts
        self.partParameters = parameters
        self.headers["Content-Type"] = "multipart/form-data; boundary=\(boundary ?? MultipartParameters.boundary)"
    }
    
    public override func getData() throws -> Data? {
        guard let parts = parts else { return nil }
        let boundary = self.boundary ?? MultipartParameters.boundary
        
        var data = try partParameters?.encode(withBoundary: boundary) ?? Data()
        try parts.forEach({ data.append(try $0.encode(withBoundary: boundary))})
        try data.append(string: "--\(boundary)--\r\n")
        return data
    }
}

extension Dictionary where Key == String {
    func encode(withBoundary boundary: String) throws -> Data {
        var content = Data()
        for (key, value) in self {
            try content.append(string: "--\(boundary)\r\n")
            try content.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            try content.append(string: "\(value)\r\n")
        }
        return content
    }
}
