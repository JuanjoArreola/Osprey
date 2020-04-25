# Osprey

Networking for Swift 5.

A Library to connect to APIs built on top of URLSession.

#### Features:
- Lightweight
- Not *format specific*

#### Considerations:
- It depends on a Promises Library
- Might not be the best option if download or upload tasks are necessary

#### Installation
- Swift Package Manager

### Quickstart

This quick example demonstrates how to get a Github user's repositories:
Mapping the API Model:

```swift
struct Repository: Decodable {
    var name: String
}
```

Creating an *API*:

```swift
class RepositoriesAPI: AbstractAPI {
    func repositoriesOf(_ username: String) -> Promise<[Repository]> {
        return request(route: .get("https://api.github.com/users/\(username)/repos"))
    }
}
```

Consuming the API:

```swift
let api = RepositoriesAPI(responseParser: JSONParser())

api.repositoriesOf("username").onSuccess { repositories in
    print(repositories)
}.onError { error in
    print(error)
}
```

### Overview

The goal of Osprey is to be able to write API Clients in a clear and simple way having the 
flexibility to customize the encoding of parameters and the parsing of the responses to 
accommodate many of the common styles in which APIs are structured. 

The first step to make a request with Osprey is to define all the information that will be sent,
this information is divided in two parts:

- **Route**, conformed of Method and URL.
- **Request parameters**, can contain URL parameters, body data and headers.  

This is to separate the *simple* information always required to make a request (Method and URL)
from the optional information that can take many forms or require additional processing
(URL query params, body and headers).

When the networking client calls the `request` method with the **Route** and **Request parameters**
a **Promise** instance is returned immediately and all the processing necessary to make the actual http
request (setting URL query parameters, encoding body data , setting headers, etc.) is made by a 
background queue.

When the response is received in a background queue, the data is parsed and the 
result (success or error) is made available by fulfilling the returned **Promise**

### Making Requests

#### Routes

The first parameter to make a request is the  `Route`:

```swift
func user() -> Promise<User> {
    return request(route: Route.get("https://api/users"))
}
```
Many of the common HTTP Methods are available `GET` `POST` `PUT` `DELETE` `HEAD` `PATCH` `OPTIONS`:

```swift
Route.get("https://api/users")
Route.post("https://api/users")
Route.patch("https://api/users")
Route.delete("https://api/users")
// ...

```

If the API has a base URL, the API Client can conform to the `BaseAPI` protocol to simplify the routes:

```swift
class ProductsAPI: AbstractAPI, BaseAPI {
    static var baseURL = "https://myapi"
    
    func requestProducts() -> Promise<[Product]> {
        return request(route: get(endpoint: "/products"))
    }
}
```

#### URL Parameters

To send URL query parameters, call the request method with the `parameters` parameter:

```swift
func requestProducts() -> Promise<[Product]> {
    let params = URLParameters(["page": 1])
    return request(route: get(endpoint: "/products"), parameters: params)
}
}
```

#### Encoders

Osprey has a few parameter encoders included: JSON, Multipart, FormUrl, but is not limited 
to those, you can add your own custom encoder by conforming to the `RequestParameters` protocol

##### JSON

To encode your parameters as JSON use the `JSONParameters` class:

```swift
func addProduct(_ product: Product) -> Promise<Product> {
    let params = JSONParameters(product)
    return request(route: post(endpoint: "/products/"), parameters: params)
}
```

##### Multipart

```swift
func addPicture(_ data: Data, to product: Product) -> Promise<Picture> {
    let part = Part(mimeType: .png, name: "picture", filename: UUID().uuidString, data: data)
    let params = MultipartParameters(parts: [part])
    return request(route: patch(endpoint: "/products/\(product.id)/"), parameters: params)
}
```

### Headers

Headers can be added to every `RequestParameters` instance:

```swift
let params = JSONParameters(product, headers: ["Authentication": "Token \(token)"])
let urlParams = JSONParameters(product, headers: ["Authentication": "Token \(token)"])
let multipartParams = MultipartParameters(product, headers: ["Authentication": "Token \(token)"])
```

It could also be convenient to create your own parameters type to handle some cases like Authentication:

```swift
class AuthenticatedJSONParameters: JSONParameters {
    func preprocess() throws {
        headers["Authentication"] = try UserManager.shared.getToken()
    }
}

let params = AuthenticatedJSONParameters(product)
```

### Getting Responses

API Clients inherit from the `AbstractAPI` class that provides the `request` method,
this method returns a `Promise` instance that can be used to register closures to be 
called when the response is ready or to chain more requests:

```swift
usersAPI.requestUser()
.then(api.getFavorites(of:))
.onSuccess(updateProducts)
.onError(logError)
.finally(updateInterface)
```
All this closures are called in the main queue, to change that behaviour you can configure your 
client setting the ``variable:

```swift
let api = UsersAPI(responseParser: JSONParser())
api.responseQueue = .global()
```

You can also set the queue in which a single closure will be called:

```swift
api.requestUser()
.then(in: backgroundQueue, api.getFavorites(of:))
.onSuccess(in: backgroundQueue, cacheProducts)
.onSuccess(in: .main, updateProducts)
.onError(in: backgroundQueue, reportError(_:))
.onError(in: .main, alertError(_:))
.finally(in: .main, updateInterface)
```

#### Parsers

API Clients need a response parser to deserialize data into your model instances,
Osprey includes a `JSONParser` that handles json data, you can define your own parsers by
confirming to the `ResponseParser` protocol.

The `JSONParser` expects models as the root of the json data, to change this behaviour you
can subclass the `JSONParser` to adapt to the format.

The following example demonstrates how to parse json data that contains metadata:

```json
{
    "page": {
        "number": 1,
        "size": 50
    },
    "success": true,
    "results": [
        {
            "id": 1,
            "name": "Product 1"
        },
        {
            "id": 2,
            "name": "Product 2"
        }
    ]
}
```

```swift
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

let productsAPI = ProductsAPI(responseParser: CustomJSONParser())
```
