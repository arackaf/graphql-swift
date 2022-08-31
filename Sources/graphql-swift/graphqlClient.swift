import Foundation


public struct GenericGraphQLRequest<T: Codable> : Codable {
    let query: String
    let variables: T
    
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
    
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }
    
    open func adjustRequest(_ request: inout URLRequest) {}
    
    public func run<T, D: Encodable>(requestBody: D, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        guard let graphqlRequestPacket = try? JSONEncoder().encode(requestBody) else {
            print("Error: Trying to convert model to JSON data")
            return nil
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = graphqlRequestPacket
        
        adjustRequest(&request)
        
        return try? await run(request: request, produceResult)
    }

    public func run<T>(request: URLRequest, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        let jsonResult = try await jsonRequest(request);
        
        let graphqlData = jsonResult["data"] as? [String: Any];
        guard let graphqlData = graphqlData else {
            return nil
        }
        return produceResult(graphqlData)
    }

}
