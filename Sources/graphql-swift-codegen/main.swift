import Foundation
import graphql_swift

for argument in CommandLine.arguments {
    print(argument)
}

let graphqlUrl = "https://mylibrary.onrender.com/graphql-public"

func run() async {
    do {
        print("calling networkRequest()")
        
        let client = GraphqlClient(endpoint: URL(string: graphqlUrl)!)
        let schemaGenerator = SchemaTypeGenerator(client: client)
        let response = try await schemaGenerator.readInputTypes()
        
        if let response = response {
            for type in response {
                print(type.name)
                print("---------")
                
                for field in type.fields {
                    print(field.name, field.type)
                }
                
                print("\n\n")
            }
        }
    } catch {
        print("caught")
    }
}

let myGroup = DispatchGroup()
myGroup.enter()

Task {
    print("before")
    await run()
    
    print("after")
    myGroup.leave() //// When your task completes
}

myGroup.wait()

