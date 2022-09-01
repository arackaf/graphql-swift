import Foundation
import graphql_swift

public func generateSchema(fromEndpoint: URL, generateTo: String) async throws {
    let client = GraphqlClient(endpoint: fromEndpoint)

    let rootOutputUrl = URL(fileURLWithPath: generateTo)
    let inputTypesPath = rootOutputUrl.appendingPathComponent("input-types")
    let typesPath = rootOutputUrl.appendingPathComponent("types")
    let queriesPath = rootOutputUrl.appendingPathComponent("queries")
    
    try ensurePaths(rootOutputUrl, inputTypesPath, typesPath, queriesPath)
    
    let schemaGenerator = SchemaTypeGenerator(client: client)
    let inputTypesResponse = try await schemaGenerator.readInputTypes()
    let typesResponse = try await schemaGenerator.readTypes()
    let queriesResponse = try await schemaGenerator.readQueries()

    let typeGenerator = TypeGenerator();

    if let inputTypesResponse = inputTypesResponse {
        for type in inputTypesResponse {
            typeGenerator.writeInputType(url: inputTypesPath, inputType: type)
        }
    }
    
    let TypesSkip: Set<String> = ["__Directive", "__EnumValue", "__Field", "__InputValue", "__Schema", "__Type", "Query"]
    
    if let typesResponse = typesResponse {
        for type in typesResponse.filter({ !TypesSkip.contains($0.name) }) {
            typeGenerator.writeType(url: typesPath, type: type)
        }
    }
    
    if let queriesResponse = queriesResponse {
        for query in queriesResponse {
            typeGenerator.writeQuery(url: queriesPath, query: query)
        }
    }
}

func ensurePaths(_ paths: URL...) throws {
    for path in paths {
        try ensurePath(path)
    }
}

func ensurePath(_ dir: URL) throws {
    var isDir: ObjCBool = true
    
    if !FileManager.default.fileExists(atPath: dir.path, isDirectory: &isDir) {
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    }
    
    if !isDir.boolValue {
        throw CodegenError.codeGenDirectoryCreationError("Error creating \(dir.path) - a file with this name already exists")
    }
}
