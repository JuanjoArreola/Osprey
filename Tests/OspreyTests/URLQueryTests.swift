//
//  URLQueryTests.swift
//  OspreyTests
//
//  Created by Juan Jose Arreola Simon on 08/09/20.
//

import XCTest
import Osprey

class URLQueryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLQueryValueConvertible() throws {
        var query = URLQuery()
        query.add("icecream", value: Icecream(id: 1, flavor: "Vanilla"))
        XCTAssertEqual(query.urlQuery, "icecream=1")
    }
    
    func testDuplicateURLQueryValueConvertible() throws {
        var query = URLQuery()
        query.add("icecream", value: Icecream(id: 1, flavor: "Vanilla"))
        query.add("icecream", value: Icecream(id: 2, flavor: "Chocolate"))
        XCTAssertEqual(query.urlQuery, "icecream=1&icecream=2")
    }
    
    func testURLQueryConvertible() throws {
        let query = URLQuery(Coordinate(latitude: -19.0, longitude: 99.1))
        XCTAssertEqual(query.urlQuery, "latitude=-19.0&longitude=99.1")
    }
    
    func testConvertible() throws {
        var query = URLQuery()
        query.add("icecream", value: Icecream(id: 1, flavor: "Vanilla"))
        query.add(Coordinate(latitude: -19.0, longitude: 99.1))
        XCTAssertEqual(query.urlQuery, "icecream=1&latitude=-19.0&longitude=99.1")
    }
    
    func testCustomStringConvertible() throws {
        var query = URLQuery()
        query.add("point", value: Point(x: 3, y: 7))
        XCTAssertEqual(query.urlQuery, "point=(3,7)")
    }

}

struct Icecream: URLQueryValueConvertible {
    var id: Int
    var flavor: String
    
    var urlQueryValue: String {
        return "\(id)"
    }
}

struct Coordinate: URLQueryConvertible {
    var latitude: Double
    var longitude: Double
    
    var urlQuery: String {
        return "latitude=\(latitude)&longitude=\(longitude)"
    }
}

struct Point: CustomStringConvertible, URLQueryValueConvertible {
    let x: Int, y: Int
    
    var description: String {
        return "(\(x),\(y))"
    }
}
