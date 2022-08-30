import Foundation

let GQL_TAB = "  "
let TAB = "    "
let MAX_ARGS = 5

func printStructFields(_ identifiers: [GraphqlIdentifier]) -> String {
    return TAB + identifiers.map({ "var \($0.name): \($0.swiftType)" }).joined(separator: "\n" + TAB)
}

func printFunctionArgs(_ args: [GraphqlIdentifier]) -> String {
    guard !args.isEmpty else {
        return "()"
    }
    let allArgs = args.map { "\($0.name): \($0.swiftType)" }
    
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
    let allArgs = args.map { "$\($0.name): \($0.graphqlType)" }
    
    if args.count > MAX_ARGS {
        return "(\n\(GQL_TAB)\(allArgs.joined(separator: ",\n" + GQL_TAB))\n)"
    } else {
        return "(\(allArgs.joined(separator: ", ")))"
    }
}

func printFieldsEnum(_ fields: [GraphqlIdentifier]) -> String {
    guard !fields.isEmpty else {
        return ""
    }
    
    return """
\(TAB)enum Fields: String {
\(TAB + TAB)\(fields.map { "case \($0.name)" }.joined(separator: "\n\(TAB + TAB)"))
\(TAB)}
"""
}

let imports = """
import Foundation
import graphql_swift
"""

struct TypeGenerator {
    func writeInputType(url: URL, inputType: GraphqlInputType) {
        let destination = url.appendingPathComponent("\(inputType.name).swift");
        let fileContents = imports + "\n\nstruct \(inputType.name) {\n" + printStructFields(inputType.fields) + "\n}"
        
        do {
            try fileContents.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
    
    func writeType(url: URL, type: GraphqlType) {
        let destination = url.appendingPathComponent("\(type.name).swift");
        
        let typeContents = """
struct \(type.name) {
\(printStructFields(type.fields))
 
\(printFieldsEnum(type.fields.filter({ $0.isAtomic })))
}
"""
        
        let resultBuilderContents = """
class \(type.name)Results {
    private let resultsBuilder = GraphqlResultsBuilder<\(type.name).Fields>()
    
    func emits() throws -> String {
        try resultsBuilder.emit()
    }
    
    func withFields(_ fields: \(type.name).Fields...) {
        resultsBuilder.withFields(fields)
    }
}
"""
        
        let fileContents = [imports, typeContents, resultBuilderContents].joined(separator: "\n\n")
        
        do {
            try fileContents.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
    func writeQuery(url: URL, query: GraphqlQueryType) {
        let destination = url.appendingPathComponent("\(query.name).swift")
        
        let capitalizedName = query.name.prefix(1).capitalized + query.name.dropFirst()
        
        let funcDefinition = "func \(query.name)(_ filters: \(capitalizedName)Filters) -> \(query.returnType)? {\n\(TAB)return nil\n}"
        
        let filtersStruct = """
struct \(capitalizedName)Filters {
\(printStructFields(query.args))
}
"""
        
        let queryText = """
fileprivate let queryText = \"\"\"
query \(query.name) \(printGraphqlArgs(query.args)){
\(GQL_TAB)\(GQL_TAB)\(query.args.map{ "\($0.name): $\($0.name)" }.joined(separator: "\n" + GQL_TAB + GQL_TAB))
}
\"\"\"
"""
        
        do {
            let pieces = [imports, queryText, filtersStruct, funcDefinition]
            let wholeFile = pieces.joined(separator: "\n\n")
            
            try wholeFile.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
}
