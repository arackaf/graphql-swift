import Foundation

enum NetworkRequestError: Error {
    case NoResponse
    case NonHttpResponse(URLResponse)
    case BadResponseCode(Int)
    case BadData
    case NonJsonResponse
}

extension Dictionary where Key == String {
    func val(_ key: String) -> [String: Any]? {
        return self[key] as? [String:Any]
    }
    
    func arr(_ key: String) -> [[String: Any]]? {
        return self[key] as? [[String:Any]]
    }
    
    func get<T>(_ key: String) -> T? {
        return self[key] as? T
    }
}

extension Array where Element == Dictionary<String, Any> {
    func produce<T>() -> [T]? where T:InitializableFromJSON {
        return self.map { T($0) }
    }
}

protocol InitializableFromJSON {
    init(_ json: [String: Any])
}

struct GraphqlFieldType: InitializableFromJSON {
    let name: String
    let type: String?
    
    init(_ json: [String: Any]){
        name = json.get("name")!
        type = json.get("type")
    }
}

struct GraphqlSchemaType: InitializableFromJSON {
    let kind: String
    let name: String
    let fields: [GraphqlFieldType]?
    
    init(_ json: [String: Any]){
        kind = json.get("kind")!
        name = json.get("name")!
        fields = json.arr("fields")?.produce()
    }
}

func networkRequest(_ request: URLRequest) async throws -> Data? {
    return try await withUnsafeThrowingContinuation { cont in
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                cont.resume(throwing: error)
                return
            }
            guard let response = response else {
                return cont.resume(throwing: NetworkRequestError.NoResponse)
            }
            guard let response = response as? HTTPURLResponse else {
                return cont.resume(throwing: NetworkRequestError.NonHttpResponse(response))
            }
            if !(200 ..< 299).contains(response.statusCode) {
                return cont.resume(throwing: NetworkRequestError.BadResponseCode(response.statusCode))
            }
            
            return cont.resume(returning: data)
            
        }.resume()
        print("after resume")
    }
}

func jsonRequest(_ request: URLRequest) async throws -> [String: Any] {
    let data = try await networkRequest(request)
    
    guard let data = data else {
        throw NetworkRequestError.BadData
    }
    
    //print(data.getSome())
    
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        print("Error: Cannot convert data to JSON object")
        print("\n\n")
        //print(data)
        
        throw NetworkRequestError.NonJsonResponse
    }
    
    return jsonObject
}

func graphqlRequest<T>(_ request: URLRequest, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
    let jsonResult = try await jsonRequest(request);
    
    let graphqlData = jsonResult.val("data");
    guard let graphqlData = graphqlData else {
        return nil
    }
    return produceResult(graphqlData)
}

struct GraphqlQueryRequest: Codable {
    let query: String
}

let GRAPHQL_SCHEMA_REQUEST = """
    {
      __schema {
        types {
          kind
          name
          fields{
            name
            type {
              name
              description
              ofType{
                name
                kind
              }
            }
          }
        }
      }
    }
"""
