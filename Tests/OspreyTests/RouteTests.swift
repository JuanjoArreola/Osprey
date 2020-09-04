//
//  RouteTests.swift
//  OspreyTests
//
//  Created by JuanJo on 04/09/20.
//

import XCTest
import Osprey

class RouteTests: XCTestCase, BaseAPI {
    
    let baseURL = "http://localhost:8000/"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetEmptyParams() throws {
        let route = Route.get(baseURL)
        let url = try route.getURL(with: nil)
        XCTAssertEqual(url.absoluteString, baseURL)
    }
    
    func testGetInvalidURL() throws {
        let route = Route.get("# localhost:8000/")
        XCTAssertThrowsError(try route.getURL(with: nil))
    }
    
    func testGetEndpoint() throws {
        let route = get(endpoint: "service/")
        let params = URLParameters(["foo": "bar"])
        let url = try route.getURL(with: params)
        XCTAssertEqual(url.absoluteString, "http://localhost:8000/service/?foo=bar")
    }
    
    func testGet() throws {
        let route = Route.get(baseURL)
        let params = URLParameters(["foo": "bar"])
        let url = try route.getURL(with: params)
        XCTAssertEqual(url.absoluteString, "http://localhost:8000/?foo=bar")
    }
    
    func testPost() throws {
        let route = Route.post(baseURL)
        let params = URLParameters(["foo": "bar", "1": "one"])
        let url = try route.getURL(with: params)
        XCTAssertTrue(url.absoluteString == "http://localhost:8000/?foo=bar&1=one" ||
            url.absoluteString == "http://localhost:8000/?1=one&foo=bar")
    }

}
