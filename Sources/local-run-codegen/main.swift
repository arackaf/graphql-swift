import Foundation
import graphql_swift
import graphql_codegen


let graphqlUrl = "https://mylibrary.onrender.com/graphql"

func run() async {
    do {
        print("calling networkRequest()")

        try await generateSchema(fromEndpoint: URL(string: graphqlUrl)!, generateTo: "/Users/arackis/Documents/git/swift-codegen");
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
