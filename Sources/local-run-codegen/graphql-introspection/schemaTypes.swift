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
        var name: String? = json.get("name")
        if name == "Boolean" {
            name = "Bool"
        }
        
        if let name = name {
            return name + modifier
        }
        return getType(json.object("ofType")!, nullable: nullable)
    }
}

public struct GraphqlIdentifier: InitializableFromJSON {
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
    public let fields: [GraphqlIdentifier]
    
    init(json: [String: Any]){
        name = json.get("name")!
        fields = json.array("inputFields")?.produce() ?? []
    }
}

public struct GraphqlType: InitializableFromJSON {
    public let name: String
    public let fields: [GraphqlIdentifier]
    
    init(json: [String: Any]){
        name = json.get("name")!
        fields = json.array("fields")?.produce() ?? []
    }
}

public struct GraphqlQueryType: InitializableFromJSON {
    public let name: String
    public let returnType: String
    public let args: [GraphqlIdentifier]
    
    init(json: [String: Any]){
        name = json.get("name")!
        
        let typeField = json.object("type")!
        returnType = getType(typeField)
        
        args = json.array("args")?.produce() ?? []
    }
}
