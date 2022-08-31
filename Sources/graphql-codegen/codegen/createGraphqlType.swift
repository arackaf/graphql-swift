import Foundation

let GQL_TAB = "  "
let TAB = "    "
let MAX_ARGS = 5

func printStructFields(_ identifiers: [GraphqlIdentifier], forceNullable: Bool = false) -> String {
    return TAB + identifiers.map({ "var \($0.name): \(forceNullable ? $0.nullableSwiftType : $0.swiftType)" }).joined(separator: "\n" + TAB)
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
        return "\(TAB)enum Fields: String { case empty }"
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
        let fileContents = imports + "\n\nstruct \(inputType.name): Codable {\n" + printStructFields(inputType.fields) + "\n}"
        
        do {
            try fileContents.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
    
    func writeType(url: URL, type: GraphqlType) {
        let destination = url.appendingPathComponent("\(type.name).swift");
        
        let typeContents = """
struct \(type.name): Codable {
\(printStructFields(type.fields, forceNullable: true))
 
\(printFieldsEnum(type.fields.filter({ $0.isAtomic })))
}
"""
        let atomicFields = type.fields.filter({ $0.isAtomic })
        let nonAtomicFields = type.fields.filter({ !$0.isAtomic })
        
        let withFieldsDefinition = atomicFields.isEmpty ? "" :
        """

    @discardableResult
    func withFields(_ fields: \(type.name).Fields...) -> Self {
        resultsBuilder.withFields(fields)
        return self
    }
"""
        
        let resultBuilderDefinitions = nonAtomicFields.isEmpty ? "" : nonAtomicFields.map({ def in
            let capitalizedName = def.name.prefix(1).capitalized + def.name.dropFirst()
            
            return """
    
    @discardableResult
    func with\(capitalizedName)(_ build: (\(def.rootType)Builder) -> ()) -> Self {
        let res = \(def.rootType)Builder("\(def.name)")
        build(res)
        resultsBuilder.addResultSet(res)

        return self
    }
"""
        }).joined(separator: "\n")
        
        let resultBuilderContents = """
class \(type.name)Builder: GraphqlResults {
    private let resultsBuilder = GraphqlResultsBuilder<\(type.name).Fields>()
    
    init() {}
    init(_ name: String) {
        resultsBuilder.setName(name);
    }

    func emit() throws -> String {
        try resultsBuilder.emit()
    }
\(withFieldsDefinition)
\(resultBuilderDefinitions)
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
        let filtersType = "\(capitalizedName)Filters"
        let requestType = "GenericGraphQLRequest<\(filtersType)>"
        
        //\(query.returnType)?
        let funcDefinition = """
func \(query.name)(_ filters: \(filtersType), buildSelection: (\(query.rootReturnType)Builder) -> ()) throws -> \(requestType) {
    let selectionBuilder = \(query.rootReturnType)Builder()
    buildSelection(selectionBuilder)

    let selectionText = try selectionBuilder.emit()
    let query = getQueryText(selectionText);

    return \(requestType)(query: query, variables: filters)
}
"""
        
        let filtersStruct = """
struct \(capitalizedName)Filters: Codable {
\(printStructFields(query.args))
}
"""
        
        let queryText = """
fileprivate func getQueryText(_ selection: String) -> String {
    return \"\"\"
query \(query.name) \(printGraphqlArgs(query.args)) { \n  \(query.name) (
    \(query.args.map{ "\($0.name): $\($0.name)" }.joined(separator: "\n    "))
)

\\(selection)

}
\"\"\"
}
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
