import Foundation
import graphql_swift

struct AuthenticatedGraphqlRequest<T: Codable>: Codable {
    let query: String
    let variables: T
    let loginToken: String 
}

class AuthenticatedGraphqlClient: GraphqlClient {
    static var loginToken: String = ""
    
    override func encodeRequestBody<D: Codable>(_ request: GenericGraphQLRequest<D>) throws -> Data {
        let authenticatedRequest = AuthenticatedGraphqlRequest(query: request.query, variables: request.variables, loginToken: Self.loginToken)
        return try encodeBody(authenticatedRequest)
    }
    
    static func login() async throws {
        Self.loginToken = try await authenticate()
    }
}

func foo() async throws {
    try await AuthenticatedGraphqlClient.login()
    
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
    

    let client = AuthenticatedGraphqlClient(endpoint: URL(string: "https://my-library-io.herokuapp.com/graphql-ios")!)
    
    func decode(_ json: Data) -> BookQueryResults? {
        let decoder = JSONDecoder()
        return try? decoder.decode(BookQueryResults.self, from: json)
    }
    
    let a = try await client.runQuery(result)

    print("count", a.data.allBooks.Books?.count)
    print("title = ", a.data.allBooks.Books?[0].title)
}


let myGroup = DispatchGroup()
myGroup.enter()

Task {
    try? await foo()
    
    myGroup.leave() //// When your task completes
}

myGroup.wait()
