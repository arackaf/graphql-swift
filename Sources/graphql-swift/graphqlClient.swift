import Foundation

public typealias QueryPacket<Req: Codable, Res: Codable> = (request: GenericGraphQLRequest<Req>, SerializedResult: Res.Type)

public struct GraphqlResponse<T: Codable>: Codable {
    public let data: T
}

public struct GenericGraphQLRequest<T: Codable> : Codable {
    public let query: String
    public let variables: T
    
    public init(query: String, variables: T) {
        self.query = query
        self.variables = variables
    }
}

func decodeResponse<T: Decodable>(_ result: Data) throws -> T? {
    let decoder = JSONDecoder()
    
    return try decoder.decode(T.self, from: result)
}


open class GraphqlClient {
    let endpoint: URL
    
    public enum GraphqlClientErrors: Error {
        case badRequestEncoding
        case invalidResult
    }
    
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }
    
    public func encodeBody<D: Codable>(_ request: D) throws -> Data {
        guard let result = try? JSONEncoder().encode(request) else {
            throw GraphqlClientErrors.badRequestEncoding
        }
        
        return result
    }
    
    open func encodeRequestBody<D: Codable>(_ request: GenericGraphQLRequest<D>) throws -> Data {
        return try encodeBody(request)
    }
    
    public func runQuery<D, T>(_ request: QueryPacket<D, GraphqlResponse<T>>) async throws -> T {
        return try await run(requestBody: request.request) { (res) throws -> T in
            let decoder = JSONDecoder()
            let result = try decoder.decode(GraphqlResponse<T>.self, from: res)
            
            return result.data
        }
    }
    
    public func runSchemaQuery<T>(_ query: String, _ produceResult: (([String: Any]) throws -> T)) async throws -> T {
        let requestBody = GenericGraphQLRequest(query: query, variables: nil as String?)
        let requestData = try encodeRequestBody(requestBody)
        
        return try await run(requestData: requestData) { (data) -> T in
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                
                throw NetworkRequestError.nonJsonResponse
            }
            
            return try produceResult(jsonObject)
            
        }
    }
    
    public func run<T, D: Encodable>(requestBody: GenericGraphQLRequest<D>, _ produceResult: ((Data) throws -> T)) async throws -> T {
        let requestData = try encodeRequestBody(requestBody)
        
        return try await run(requestData: requestData, produceResult)
    }
    
    public func run<T>(requestData: Data, _ produceResult: ((Data) throws -> T)) async throws -> T {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = requestData
        
        return try await run(request: request, produceResult)
    }

    public func run<T>(request: URLRequest, _ produceResult: ((Data) throws -> T)) async throws -> T {
        let data = try await networkRequest(request);
        
        return try produceResult(data)
    }

}
