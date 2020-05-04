//
//  RequestParametersTests.swift
//  OspreyTests
//
//  Created by Juan Jose Arreola Simon on 04/05/20.
//

import XCTest
import Osprey

class CustomParameters: URLParameters {
    func preprocess() throws {
        headers["Authorization"] = "Token"
    }
}

class CustomJSONParameters: JSONParameters {
    func preprocess() throws {
        headers["Authorization"] = "Token"
    }
}

fileprivate struct Test: Encodable {
    var name: String
}

class RequestParametersTests: XCTestCase {

    func testURLParameters() throws {
        let params = URLParameters(["search": "test", "page": 1])
        let get = Route.get("http://localhost/service/")
        let url = try get.getURL(with: params)
        XCTAssertTrue(url.query == "search=test&page=1" || url.query == "page=1&search=test")
        XCTAssertNil(try params.getData())
    }
    
    func testURLParametersPreprocess() throws {
        let params = CustomParameters()
        try params.preprocess()
        XCTAssertGreaterThan(params.headers.count, 0)
        XCTAssertTrue(params.headers.contains(where: { $0.key == "Authorization" && $0.value == "Token" }))
    }
    
    func testJSONParameters() throws {
        let params = JSONParameters(Test(name: "test"))
        let data = try params.getData()
        XCTAssertNotNil(data)
    }
    
    func testJSONParametersPreprocess() throws {
        let params = CustomJSONParameters()
        try params.preprocess()
        XCTAssertGreaterThan(params.headers.count, 0)
        XCTAssertTrue(params.headers.contains(where: { $0.key == "Authorization" && $0.value == "Token" }))
    }

}
