//
//  JSONParametersTests.swift
//  OspreyTests
//
//  Created by JuanJo on 05/05/20.
//

import XCTest
import Osprey

fileprivate struct Test: Encodable {
    var name: String
}

class JSONParametersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeferredData() throws {
        let params = JSONParameters(Test(name: "test"))
        XCTAssertNil(params.data)
        XCTAssertNotNil(try params.getData())
        XCTAssertEqual(params.data, "{\"name\":\"test\"}".data(using: .utf8))
    }

}
