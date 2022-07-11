import Foundation

struct GraphqlSchemaRequest: Codable {
    let query: String
}

public struct SchemaTypeGenerator {
    let client: GraphqlClient
    
    public init(client: GraphqlClient) {
        self.client = client
    }
    
    public func readInputTypes() async throws -> [GraphqlInputType]? {
        let requestData = GraphqlSchemaRequest(query: graphqlSchemaInputTypesRequest)
        
        let response: [GraphqlInputType]? = try await client.run(requestBody: requestData) { data in
            data.object("__schema")?.array("types")?.filter({ $0.get("kind") == "INPUT_OBJECT" }).produce()
        }
        
        return response
    }
    
    public func readTypes() async throws -> [GraphqlType]? {
        let requestData = GraphqlSchemaRequest(query: graphqlSchemaTypesRequest)
        
        let response: [GraphqlType]? = try await client.run(requestBody: requestData) { data in
            data.object("__schema")?.array("types")?.filter({ $0.get("kind") == "OBJECT" }).produce()
        }
        
        return response
    }
    
    public func readQueries() async throws -> [GraphqlQueryType]? {
        let requestData = GraphqlSchemaRequest(query: graphqlSchemaQueriesRequest)
        
        let response: [GraphqlQueryType]? = try await client.run(requestBody: requestData) { data in
            data.object("__schema")?.object("queryType")?.array("fields")?.produce()
        }
        
        return response
    }
}
