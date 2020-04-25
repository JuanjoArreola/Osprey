//
//  JSONParser.swift
//  Osprey
//
//  Created by JuanJo on 21/04/20.
//

import Foundation

open class JSONParser: ResponseParser {
    public let decoder = JSONDecoder()
    private let formatter = DateFormatter()
    
    public init() {
        guard let parser = self as? CustomDateParsing else {
            decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.secondsSince1970
            return
        }
        formatter.locale = parser.locale
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom({ decoder -> Date in
            let string = try decoder.singleValueContainer().decode(String.self)
            if let date = self.date(from: string, using: parser.dateFormats) {
                return date
            }
            throw ResponseError.invalidDate(string: string)
        })
    }
    
    open func date(from string: String, using formats: [String]) -> Date? {
        for format in formats {
            self.formatter.dateFormat = format
            if let date = self.formatter.date(from: string) {
                return date
            }
        }
        return nil
    }
    
    open func getInstance<T: Decodable>(from data: Data, response: URLResponse?) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
    
    open func getError(from data: Data?, response: URLResponse?) throws -> Error? {
        return nil
    }
}

public protocol CustomDateParsing {
    var dateFormats: [String] { get }
    var locale: Locale { get }
}

public extension CustomDateParsing {
    var locale: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
}
