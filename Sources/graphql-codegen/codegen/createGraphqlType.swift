import Foundation

let TAB = "    "

struct TypeGenerator {
    func writeInputType(url: URL, inputType: GraphqlInputType) {
        let destination = url.appendingPathComponent("\(inputType.name).swift");
        let fileContents = "struct \(inputType.name) {\n" + inputType.fields.map {
            return "\(TAB)var \($0.name): \($0.type)"
        }.joined(separator: "\n") + "\n}"
        
        do {
            try fileContents.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
    func writeType(url: URL, type: GraphqlType) {
        let destination = url.appendingPathComponent("\(type.name).swift");
        let fileContents = "struct \(type.name) {\n" + type.fields.map {
            return "\(TAB)var \($0.name): \($0.type)"
        }.joined(separator: "\n") + "\n}"
        
        do {
            try fileContents.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
    func writeQuery(url: URL, query: GraphqlQueryType) {
        let destination = url.appendingPathComponent("\(query.name).swift");


        let argsString = query.args.map{ $0.name + ": " + $0.type }.joined(separator: ", ")
            
        let funcDefinition = "func \(query.name)(\(argsString)) -> \(query.returnType) {\n" + "}"
                
        do {
            try funcDefinition.write(to: destination, atomically: true, encoding: String.Encoding.utf8)
        } catch  {
            print("Caught error \(error)")
        }
    }
}
