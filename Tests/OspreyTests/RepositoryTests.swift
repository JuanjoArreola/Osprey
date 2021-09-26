//
//  RepositoryTests.swift
//  OspreyTests
//
//  Created by Juan Jose Arreola Simon on 24/04/20.
//

import XCTest
import Osprey

class User: Codable {
    var name: String
    var token: String
}

struct Product: Codable {
    var id: Int
    var name: String
}

struct Picture: Decodable {
    var url: URL
}

class UsersAPI: AbstractAPI, RestAPI {
    var resource: String = ""
    var baseURL: String = "https://api.project.com"
    
    func requestUser() async throws -> User {
        return try await request(route: get(endpoint: "/user"))
    }
    
    func getFavorites(of user: User) async throws -> [Product] {
        return try await request(route: get(endpoint: "/favorites"))
    }
    
    func updateUser(_ user: User) async throws -> User {
        let params = try RequestParameters(body: JSONBody(user))
        return try await request(route: patch(endpoint: "/user"), parameters: params)
    }
}

class UsersAPI2: AbstractAPI, RestAPI {
    var resource: String = "/user"
    var baseURL: String = "https://api.project.com"
    
    func requestUser() async throws -> User {
        return try await request(route: all())
    }
    
    func getFavorites(of user: User) async throws -> [Product] {
        return try await request(route: get(endpoint: "/favorites"))
    }
    
    func updateUser(_ user: User) async throws -> User {
        let params = try RequestParameters(body: JSONBody(user))
        return try await request(route: update(), parameters: params)
    }
}

let token = ""

class UserManager {
    static var shared = UserManager()
    func getToken() throws -> String {
        return ""
    }
}

struct Page: Decodable {
    var number: Int
    var size: Int
}

struct Response<T: Decodable>: Decodable {
    var page: Page
    var results: T
}

class CustomJSONParser: JSONParser {
    override func getInstance<T>(from data: Data, response: URLResponse?) throws -> T where T : Decodable {
        let response = try decoder.decode(Response<T>.self, from: data)
        return response.results
    }
}

class ProductsAPI: AbstractAPI, RestAPI {
    var resource: String = "products/"
    var baseURL = "https://myapi"
    
    func requestProducts() async throws -> Product {
        let params = RequestParameters(urlQuery: ["page": 1])
        return try await request(route: all(), parameters: params)
    }
    
    func addProduct(_ product: Product) async throws -> Product {
        let params = try RequestParameters(body: JSONBody(product), headers: ["Authentication": "Token \(token)"])
        return try await request(route: create(), parameters: params)
    }
    
    func addPicture(_ data: Data, to product: Product) async throws -> Picture {
        let part = Part(mimeType: .png, data: data, attributes: ["name": "picture", "filename": UUID().uuidString])
        let params = try RequestParameters(body: MultipartBody(parts: [part]))
        return try await request(route: patch(endpoint: "\(product.id)/"), parameters: params)
    }
    
    func test() {
    }
}

struct Repository: Decodable {
    var name: String
}

class RepositoriesAPI: AbstractAPI {
    func repositoriesOf(_ username: String) async throws -> [Repository] {
        return try await request(route: .get("https://api.github.com/users/\(username)/repos"))
    }
}

class RepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGet() async throws {
        
        let api = RepositoriesAPI(responseParser: JSONParser())
        let repositories = try await api.repositoriesOf("JuanjoArreola")
        XCTAssertGreaterThan(repositories.count, 0)
    }

    func testExample() async throws {
        let api = UsersAPI(responseParser: JSONParser())
        
        var user = try await api.requestUser()
        print(user)
        user.name = "New name"
        user = try await api.updateUser(user)
        print("New name: \(user.name)")
    }
    
    func testFavorites() async throws {
        let api = UsersAPI(responseParser: JSONParser())
        
        let user = try await api.requestUser()
        let favourites = try await api.getFavorites(of: user)
        cacheProducts(favourites)
        updateProducts(favourites)
    }
    
    func cacheProducts(_ products: [Product]) {
//        let productsAPI = ProductsAPI(responseParser: CustomJSONParser())
    }
    
    func updateInterface() {
    }
    
    func alertError(_ error: Error) {
        
    }
    
    func reportError(_ error: Error) {
        
    }
    
    func updateProducts(_ products: [Product]) {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
