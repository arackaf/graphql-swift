import Foundation

open class GraphqlClient {
    let url: URL!
    
    public init(_ endpoint: String) {
        url = URL(string: endpoint)!
    }
    
    public func run<T, D: Encodable>(requestBody: D, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        guard let graphqlRequestPacket = try? JSONEncoder().encode(requestBody) else {
            print("Error: Trying to convert model to JSON data")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = graphqlRequestPacket
        
        return try? await run(request: request, produceResult)
    }

    public func run<T>(request: URLRequest, _ produceResult: (([String: Any]) -> T?)) async throws -> T? {
        let jsonResult = try await jsonRequest(request);
        
        let graphqlData = jsonResult.object("data");
        guard let graphqlData = graphqlData else {
            return nil
        }
        return produceResult(graphqlData)
    }
}
