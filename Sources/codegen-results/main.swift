import Foundation
import graphql_swift

print("Helloooo")

struct A<T: Codable>: Codable {
    let query: String
    let variables: T
    let loginToken: String 
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
    
    let packet = A(query: result.query, variables: result.variables, loginToken: loginToken)
    
    let client = GraphqlClient(endpoint: URL(string: "https://my-library-io.herokuapp.com/graphql-ios")!)
    let x = try await client.run(requestBody: packet) { json in
        //print(json);
        //let d: String
        return json
    }

    print(x)
}

let myGroup = DispatchGroup()
myGroup.enter()

Task {
    try? await foo()
    
    myGroup.leave() //// When your task completes
}

myGroup.wait()
