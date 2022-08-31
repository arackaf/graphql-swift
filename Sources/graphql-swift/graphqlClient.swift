import Foundation

public typealias QueryPacket<Req: Codable, Type: Codable> = (request: GenericGraphQLRequest<Req>, SerializedResult: Codable.Type)

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
    
    public func runQuery<T, D: Encodable>(_ request: GenericGraphQLRequest<D>) async throws -> T? {
        //let adjustedPacket = adjustGraphqlPacket(request)
        
        //await try run(requestBody: adjustedPacket) { json in
        //    return json
        //}
        
        return nil
    }
    
    open func encodeRequestBody<D: Codable>(_ request: GenericGraphQLRequest<D>) throws -> Data {
        return try encodeBody(request)
    }
    
    public func run<T, D: Encodable>(requestBody: GenericGraphQLRequest<D>, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        let requestData = try encodeRequestBody(requestBody)
        
        return try? await run(requestData: requestData, produceResult)
    }
    
    public func run<T>(requestData: Data, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = requestData
        
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
