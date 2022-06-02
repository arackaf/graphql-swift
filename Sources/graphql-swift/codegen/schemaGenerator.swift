import Foundation

struct GraphqlSchemaRequest: Codable {
    let query: String
}

public struct SchemaTypeGenerator {
    let client: GraphqlClient
    
    public func readInputTypes() async throws -> [GraphqlInputType]? {
        let requestData = GraphqlSchemaRequest(query: graphqlSchemaInputTypesRequest)
        
        let response: [GraphqlInputType]? = try await client.run(requestBody: requestData) { data in
            data.object("__schema")?.array("types")?.filter({ $0.get("kind") == "INPUT_OBJECT" }).produce()
        }
        
        return response
    }
}
