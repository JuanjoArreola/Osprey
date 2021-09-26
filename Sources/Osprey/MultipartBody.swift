//
//  MultipartBody.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

public struct MultipartBody: BodyConvertible {
    public static let boundary = "Boundary-\(UUID().uuidString)"
    
    public var data: Data
    public var boundary: String
    public var headers: [String : String]? {
        ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
    }
    
    public init(parts: [Part], parameters: [String: Any]? = nil, boundary: String = Self.boundary) throws {
        self.boundary = boundary
        var data = try parameters?.encode(withBoundary: boundary) ?? Data()
        try parts.forEach({ data.append(try $0.encode(withBoundary: boundary))})
        try data.append("--\(boundary)--\r\n")
        self.data = data
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
