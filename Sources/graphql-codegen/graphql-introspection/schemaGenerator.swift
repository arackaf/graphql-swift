import Foundation
import graphql_swift

struct GraphqlSchemaRequest: Codable {
    let query: String
}

public struct SchemaTypeGenerator {
    let client: GraphqlClient
    
    public init(client: GraphqlClient) {
        self.client = client
    }
    
    public func readInputTypes() async throws -> [GraphqlInputType]? {
        let response: [GraphqlInputType]? = try await client.runSchemaQuery(graphqlSchemaInputTypesRequest) { data in
            data.object("data")?.object("__schema")?.array("types")?.filter({ $0.get("kind") == "INPUT_OBJECT" }).produce()
        }
        
        return response
    }
    
    public func readTypes() async throws -> [GraphqlType]? {
        let response: [GraphqlType]? = try await client.runSchemaQuery(graphqlSchemaTypesRequest) { data in
            data.object("data")?.object("__schema")?.array("types")?.filter({ $0.get("kind") == "OBJECT" }).produce()
        }
        
        return response
    }
    
    public func readQueries() async throws -> [GraphqlQueryType]? {        
        let response: [GraphqlQueryType]? = try await client.runSchemaQuery(graphqlSchemaQueriesRequest) { data in
            data.object("data")?.object("__schema")?.object("queryType")?.array("fields")?.produce()
        }
        
        return response
    }
}
