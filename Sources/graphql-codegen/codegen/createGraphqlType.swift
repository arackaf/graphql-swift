import Foundation

let TAB = "    "
let MAX_ARGS = 5

func printField(_ identifier: GraphqlIdentifier) -> String {
    return "var \(identifier.name): \(identifier.type)"
}
func printArg(_ identifier: GraphqlIdentifier) -> String {
    return "\(identifier.name): \(identifier.type)"
}

func printStructFields(_ identifiers: [GraphqlIdentifier]) -> String {
    return identifiers.map(printField).joined(separator: TAB + "\n")
}

func printFunctionArgs(_ args: [GraphqlIdentifier], printEmptyArgsAs: String = "()") -> String {
    guard !args.isEmpty else {
        return printEmptyArgsAs
    }
    let allArgs = args.map(printArg)
    
    if args.count > MAX_ARGS {
        return "(\n\(TAB)\(allArgs.joined(separator: "\n" + TAB))\n)"
    } else {
        return "(\(allArgs.joined(separator: " ")))"
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
        
        let argsString = query.args.map(printArg).joined(separator: ",\n")
        let funcDefinition = "func \(query.name)\(printFunctionArgs(query.args)) -> \(query.returnType) {\n" + "}"
        
        let queryText = """
let queryText = \"\"\"
query \(query.name) \(printFunctionArgs(query.args, printEmptyArgsAs: "")){

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
