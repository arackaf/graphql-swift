import Foundation

let TAB = "    "
let MAX_ARGS = 5

func printStructFields(_ identifiers: [GraphqlIdentifier]) -> String {
    return identifiers.map({ "var \($0.name): \($0.swiftType)" }).joined(separator: TAB + "\n")
}

func printFunctionArgs(_ args: [GraphqlIdentifier]) -> String {
    guard !args.isEmpty else {
        return "()"
    }
    let allArgs = args.map({ "\($0.name): \($0.swiftType)" })
    
    if args.count > MAX_ARGS {
        return "(\n\(TAB)\(allArgs.joined(separator: ",\n" + TAB))\n)"
    } else {
        return "(\(allArgs.joined(separator: ", ")))"
    }
}

func printGraphqlArgs(_ args: [GraphqlIdentifier]) -> String {
    guard !args.isEmpty else {
        return ""
    }
    let allArgs = args.map({ "$\($0.name): \($0.graphqlType)" })
    
    if args.count > MAX_ARGS {
        return "(\n\(TAB)\(allArgs.joined(separator: ",\n" + TAB))\n)"
    } else {
        return "(\(allArgs.joined(separator: ", ")))"
    }
}

struct TypeGenerator {
    func writeInputType(url: URL, inputType: GraphqlInputType) {
        let destination = url.appendingPathComponent("\(inputType.name).swift");
        let fileContents = "struct \(inputType.name) {\n" + printStructFields(inputType.fields) + "\n}"
        
        do {
            try fileContents.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
    func writeType(url: URL, type: GraphqlType) {
        let destination = url.appendingPathComponent("\(type.name).swift");
        let fileContents = "struct \(type.name) {\n" + printStructFields(type.fields) + "\n}"
        
        do {
            try fileContents.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
    func writeQuery(url: URL, query: GraphqlQueryType) {
        let destination = url.appendingPathComponent("\(query.name).swift")
        
        let funcDefinition = "func \(query.name)\(printFunctionArgs(query.args)) -> \(query.returnType) {\n" + "}"
        
        let queryText = """
let queryText = \"\"\"
query \(query.name) \(printGraphqlArgs(query.args)){

}
\"\"\"
"""
                
        do {
            let wholeFile = queryText.appending("\n\n").appending(funcDefinition)
            
            try wholeFile.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
}
