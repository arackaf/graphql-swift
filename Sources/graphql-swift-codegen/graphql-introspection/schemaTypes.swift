import Foundation

func getType(_ json: [String: Any]) -> String {
    let kind: String? = json.get("kind")
    
    if kind == "LIST" {
        let nestedType = getType(json.object("ofType")!)
        return "Array<\(nestedType)>"
    } else if kind == "NON_NULL"{
        return getType(json.object("ofType")!)
    } else {
        return json.get("name") ?? getType(json.object("ofType")!)
    }
}

public struct GraphqlFieldType: InitializableFromJSON {
    public let name: String
    public let type: String
    public let nullable: Bool
    
    init(json: [String: Any]){
        name = json.get("name")!
        let typeField = json.object("type")!
        type = getType(typeField)
        nullable = typeField.get("kind") != "NON_NULL"
    }
}

public struct GraphqlInputType: InitializableFromJSON {
    public let name: String
    public let fields: [GraphqlFieldType]
    
    init(json: [String: Any]){
        name = json.get("name")!
        fields = json.array("inputFields")?.produce() ?? []
    }
}

public struct GraphqlType: InitializableFromJSON {
    public let name: String
    public let fields: [GraphqlFieldType]
    
    init(json: [String: Any]){
        name = json.get("name")!
        fields = json.array("fields")?.produce() ?? []
    }
}
