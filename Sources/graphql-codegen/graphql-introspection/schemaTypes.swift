import Foundation

func getSwiftType(_ json: [String: Any], nullable: Bool = true) -> String {
    let kind: String? = json.get("kind")
    let modifier: String = nullable ? "?" : ""
    
    if kind == "LIST" {
        let nestedType = getSwiftType(json.object("ofType")!)
        return "Array<\(nestedType)>\(modifier)"
    } else if kind == "NON_NULL"{
        return getSwiftType(json.object("ofType")!, nullable: false)
    } else {
        var name: String? = json.get("name")
        if name == "Boolean" {
            name = "Bool"
        }
        
        if let name = name {
            return name + modifier
        }
        return getSwiftType(json.object("ofType")!, nullable: nullable)
    }
}

fileprivate let atomicTypes: Set<String> = ["JSON", "Int", "Float", "String", "Boolean", "ID"]

func getGraphqlType(_ json: [String: Any], nullable: Bool = true) -> (type: String, atomic: Bool) {
    let kind: String? = json.get("kind")
    let modifier: String = nullable ? "" : "!"
    
    if kind == "LIST" {
        let nestedType = getGraphqlType(json.object("ofType")!)
        return ("[\(nestedType)]\(modifier)", false)
    } else if kind == "NON_NULL"{
        return getGraphqlType(json.object("ofType")!, nullable: false)
    } else {
        let name: String? = json.get("name")
        
        if let name = name {
            let atomic = atomicTypes.contains(name)
            return (name + modifier, atomic)
        }
        return getGraphqlType(json.object("ofType")!, nullable: nullable)
    }
}

public struct GraphqlIdentifier: InitializableFromJSON {
    public let name: String
    public let swiftType: String
    public let graphqlType: String
    public let isAtomic: Bool
    
    init(json: [String: Any]){
        name = json.get("name")!
        let typeField = json.object("type")!
        swiftType = getSwiftType(typeField)

        let typeInfo = getGraphqlType(typeField)
        self.graphqlType = typeInfo.type
        self.isAtomic = typeInfo.atomic
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
        returnType = getSwiftType(typeField)
        
        args = json.array("args")?.produce() ?? []
    }
}
