import Foundation
import graphql_swift

print("Helloooo")

struct AuthenticatedGraphqlRequest<T: Codable>: Codable {
    let query: String
    let variables: T
    let loginToken: String 
}

class AuthenticatedGraphqlClient: GraphqlClient {
    static var loginToken: String = ""
    
    override func adjustGraphqlPacket<D: Codable>(_ request: GenericGraphQLRequest<D>) -> Codable {
        return AuthenticatedGraphqlRequest(query: request.query, variables: request.variables, loginToken: Self.loginToken)
    }
    
    func login() async throws {
        Self.loginToken = try await authenticate()
    }
}

func foo() async throws {
    var loginToken: String
    do {
        loginToken = try await authenticate()
    } catch {
        print("Error", error)
        return
    }
    
    var filters = AllBooksFilters()
    filters.title_contains = "Jefferson"
    
    let result = try allBooks(filters) { res in
        res
            .withBooks {
                $0.withFields(.title, .isRead, .authors, .ean)
                $0.withEditorialReviews { $0.withFields(.source, .content) }
                $0.withSimilarBooks { $0.withFields(.title) }
            }
            .withMeta {
                $0.withFields(.count)
            }
    }
    
    let packet = AuthenticatedGraphqlRequest(query: result.0.query, variables: result.0.variables, loginToken: loginToken)
    
    let client = GraphqlClient(endpoint: URL(string: "https://my-library-io.herokuapp.com/graphql-ios")!)
    
    func decode(_ json: Data) -> BookQueryResults? {
        let decoder = JSONDecoder()
        return try? decoder.decode(BookQueryResults.self, from: json)
    }
    
    let decoder = JSONDecoder()
    
    let a = try await client.run(requestBody: packet) { json in
        return json
        //return try? decoder.decode(BookQueryResults.self, from: json)
    }

    print(a)
    
    /*
    let x = try await client.run(requestBody: packet) { json in
        // print(json);
        //let d: String
        return json
    }

    print(x)
     */
    
    
}


let myGroup = DispatchGroup()
myGroup.enter()

Task {
    try? await foo()
    
    myGroup.leave() //// When your task completes
}

myGroup.wait()
