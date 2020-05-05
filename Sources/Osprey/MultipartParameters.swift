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
    
    public init(parts: [Part], parameters: [String: Any]? = nil, headers: [String: String] = [:], authenticate: Bool = false) {
        super.init(headers: headers)
        
        self.parts = parts
        self.partParameters = parameters
        self.headers["Content-Type"] = "multipart/form-data; boundary=\(boundary ?? MultipartParameters.boundary)"
        self.requiresAuthentication = authenticate
    }
    
    public override func getData() throws -> Data? {
        if parts == nil && partParameters == nil { return nil }
        let boundary = self.boundary ?? MultipartParameters.boundary
        
        var data = try partParameters?.encode(withBoundary: boundary) ?? Data()
        try parts?.forEach({ data.append(try $0.encode(withBoundary: boundary))})
        try data.append("--\(boundary)--\r\n")
        return data
    }
}

extension Dictionary where Key == String {
    func encode(withBoundary boundary: String) throws -> Data {
        var content = Data()
        for (key, value) in self {
            try content.append("--\(boundary)\r\n")
            try content.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            try content.append("\(value)\r\n")
        }
        return content
    }
}
