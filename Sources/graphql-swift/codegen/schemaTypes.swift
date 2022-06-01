import Foundation

func getType(_ json: [String: Any]) -> String {
    let kind: String? = json.get("kind")
    if kind == "LIST" {
        let nestedType = getType(json.object("ofType")!)
        return "Array<\(nestedType)>"
    } else {
        return json.get("name") ?? getType(json.object("ofType")!)
    }
}

public struct GraphqlFieldType: InitializableFromJSON {
    public let name: String
    public let type: String
    
    public init(_ json: [String: Any]){
        name = json.get("name")!
        let typeField = json.object("type")!
        type = getType(typeField)
    }
}

public struct GraphqlInputType: InitializableFromJSON {
    public let name: String
    public let fields: [GraphqlFieldType]
    
    public init(_ json: [String: Any]){
        name = json.get("name")!
        fields = json.array("inputFields")?.produce() ?? []
    }
}
