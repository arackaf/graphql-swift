import Foundation

func getType(_ json: [String: Any], nullable: Bool = true) -> String {
    let kind: String? = json.get("kind")
    let modifier: String = nullable ? "?" : ""
    
    if kind == "LIST" {
        let nestedType = getType(json.object("ofType")!)
        return "Array<\(nestedType)>\(modifier)"
    } else if kind == "NON_NULL"{
        return getType(json.object("ofType")!, nullable: false)
    } else {
        let name: String? = json.get("name")
        
        if let name = name {
            return name + modifier
        }
        return getType(json.object("ofType")!, nullable: nullable)
    }
}

public struct GraphqlFieldType: InitializableFromJSON {
    public let name: String
    public let type: String
    
    init(json: [String: Any]){
        name = json.get("name")!
        let typeField = json.object("type")!
        type = getType(typeField)
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
