//
//  RequestParametersTests.swift
//  OspreyTests
//
//  Created by Juan Jose Arreola Simon on 04/05/20.
//

import XCTest
import Osprey

fileprivate struct Test: Encodable {
    var name: String
}

class RequestParametersTests: XCTestCase {

    func testURLParameters() throws {
        let params = RequestParameters(urlQuery: ["search": "test", "page": 1])
        let get = Route.get("http://localhost/service/")
        let url = try get.getURL(with: params.urlQuery)
        XCTAssertTrue(url.query == "search=test&page=1" || url.query == "page=1&search=test")
    }

}
