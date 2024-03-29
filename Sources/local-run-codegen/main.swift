import Foundation
import graphql_swift
import graphql_codegen

let graphqlUrl = "https://my-library-io.herokuapp.com/graphql"


struct Book {
    enum fields: String {
        case title
        case authors
        case publisher
    }
    
    enum empty {}
}



func run() async {
    do {
        print("calling networkRequest()")

        //try await generateSchema(fromEndpoint: URL(string: graphqlUrl)!, generateTo: "/Users/arackis/Documents/git/swift-codegen");
        try await generateSchema(fromEndpoint: URL(string: graphqlUrl)!, generateTo: "/Users/arackis/Documents/git/graphql-swift/Sources/codegen-results");
    } catch {
        print("caught")
    }
}


let myGroup = DispatchGroup()
myGroup.enter()

Task {
    await run()
    
    myGroup.leave() //// When your task completes
}

myGroup.wait()
